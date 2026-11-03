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

;; clocktable の :step day は日ごとに表を分けて出力し、ファイル×曜日の一覧にならない。
;;;###autoload
(defun org-timesheet-weekly-report (&optional weeks-ago)
  "Show clock minutes per agenda file and weekday for this week.
With prefix argument WEEKS-AGO, show the week that many weeks before."
  (interactive "P")
  (let* ((weeks-ago (if weeks-ago (prefix-numeric-value weeks-ago) 0))
         (now (decode-time))
         (monday (- (decoded-time-day now)
                    (mod (1- (decoded-time-weekday now)) 7)
                    (* 7 weeks-ago)))
         (days (mapcar (lambda (i)
                         (encode-time (list 0 0 0 (+ monday i)
                                            (decoded-time-month now) (decoded-time-year now)
                                            nil -1 nil)))
                       (number-sequence 0 7)))
         (fmt (lambda (minutes) (org-duration-from-minutes minutes 'h:mm)))
         (rows (mapcar
                (lambda (file)
                  (with-current-buffer (find-file-noselect file)
                    (cons (file-name-base file)
                          (cl-loop for (start end) on days while end
                                   collect (progn (org-clock-sum (float-time start) (float-time end))
                                                  org-clock-file-total-minutes)))))
                (org-agenda-files)))
         (totals (apply #'cl-mapcar #'+ (mapcar #'cdr rows))))
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
      (pop-to-buffer (current-buffer)))))

(add-hook 'org-clock-out-hook #'org-timesheet--clock-in-default-task-maybe)

(provide 'org-timesheet)
;;; org-timesheet.el ends here
