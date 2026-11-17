;;; org-timesheet.el --- Punch in/out and weekly clock report for Org -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'cl-lib)
(require 'org-clock)
(require 'org-id)

(defcustom org-timesheet-default-task-id "default-task"
  "ID of the heading that receives clock time while punched in.
Time is clocked here whenever no other task is clocked."
  :type 'string
  :group 'org-clock)

(defvar org-timesheet--punched-in nil)

(defun org-timesheet--clock-in-default-task ()
  (let ((marker (org-id-find org-timesheet-default-task-id 'marker)))
    (unless marker
      (user-error "No heading with ID %s" org-timesheet-default-task-id))
    (org-with-point-at marker (org-clock-in))))

(defun org-timesheet--clock-in-default-task-maybe ()
  (when (and org-timesheet--punched-in
             (not org-clock-clocking-in)
             (not org-clock-resolving-clocks-due-to-idleness))
    (org-timesheet--clock-in-default-task)))

;;;###autoload
(defun org-timesheet-punch-in ()
  "Start the working day by clocking in the default task."
  (interactive)
  (setq org-timesheet--punched-in t)
  (org-timesheet--clock-in-default-task))

;;;###autoload
(defun org-timesheet-punch-out ()
  "End the working day and stop the clock."
  (interactive)
  (setq org-timesheet--punched-in nil)
  (when (org-clocking-p)
    (org-clock-out)))

;; clocktable の :step day は日ごとに表を分けて出力し、カテゴリ×曜日の一覧にならない。
;; org-clock-sum は見出し単位で合算するため、見出しごとに異なるカテゴリを区別できない。
(defun org-timesheet--clock-ranges ()
  "Return (CATEGORY START END LINE) for each clock in the current buffer.
START and END are float times.  The running clock ends now; other
unclosed clocks are skipped."
  (org-with-wide-buffer
   (goto-char (point-min))
   (let (ranges)
     (while (re-search-forward org-clock-line-re nil t)
       (let ((element (org-element-at-point)))
         (when (eq (org-element-type element) 'clock)
           (let ((ts (org-element-property :value element))
                 (running (and (org-clocking-p)
                               (eq (marker-buffer org-clock-marker) (current-buffer))
                               (<= (org-element-property :begin element)
                                   org-clock-marker
                                   (org-element-property :end element)))))
             (when (or running (eq (org-element-property :status element) 'closed))
               (push (list (org-get-category)
                           (float-time (org-timestamp-to-time ts))
                           (if running (float-time) (float-time (org-timestamp-to-time ts t)))
                           (line-number-at-pos))
                     ranges))))))
     ranges)))

;;;###autoload
(defun org-timesheet-weekly-report (&optional weeks-ago)
  "Show clock minutes per category and weekday for this week.
Categories come from `org-get-category' at each clock line, so a
heading's CATEGORY property overrides the file's #+CATEGORY.
With prefix argument WEEKS-AGO, show the week that many weeks before."
  (interactive "P")
  (let* ((weeks-ago (if weeks-ago (prefix-numeric-value weeks-ago) 0))
         (now (decode-time))
         (monday (- (decoded-time-day now)
                    (mod (1- (decoded-time-weekday now)) 7)
                    (* 7 weeks-ago)))
         (days (mapcar (lambda (i)
                         (float-time
                          (encode-time (list 0 0 0 (+ monday i)
                                             (decoded-time-month now) (decoded-time-year now)
                                             nil -1 nil))))
                       (number-sequence 0 7)))
         (fmt (lambda (minutes) (org-duration-from-minutes minutes 'h:mm)))
         (table nil)
         (invalid nil))
    (dolist (file (org-agenda-files))
      (with-current-buffer (find-file-noselect file)
        (pcase-dolist (`(,category ,start ,end ,line) (org-timesheet--clock-ranges))
          (if (< end start)
              (push (format "%s:%d" (file-name-nondirectory file) line) invalid)
            (let ((row (or (assoc category table)
                           (car (push (cons category (make-list 7 0)) table)))))
              (cl-loop for (dstart dend) on days while dend
                       for cell on (cdr row)
                       do (cl-incf (car cell) (max 0 (floor (- (min end dend) (max start dstart)) 60)))))))))
    (let* ((rows (sort (cl-remove-if (lambda (row) (zerop (apply #'+ (cdr row)))) table)
                       (lambda (a b) (string< (car a) (car b)))))
           (totals (if rows (apply #'cl-mapcar #'+ (mapcar #'cdr rows)) (make-list 7 0))))
      (with-current-buffer (get-buffer-create "*Weekly Clock*")
        (erase-buffer)
        (org-mode)
        (insert "| | " (mapconcat (lambda (d) (format-time-string "%m/%d %a" d)) (butlast days) " | ")
                " | Total |\n|-\n")
        (dolist (row (append rows '(hline) (list (cons "Total" totals))))
          (if (eq row 'hline)
              (insert "|-\n")
            (insert "| " (car row) " | "
                    (mapconcat fmt (cdr row) " | ")
                    " | " (funcall fmt (apply #'+ (cdr row))) " |\n")))
        (org-table-align)
        (pop-to-buffer (current-buffer))))
    (when invalid
      (display-warning 'org-timesheet
                       (format "Clocks ending before they start were ignored: %s"
                               (string-join (nreverse invalid) ", "))))))

(add-hook 'org-clock-out-hook #'org-timesheet--clock-in-default-task-maybe)

(provide 'org-timesheet)
;;; org-timesheet.el ends here
