;;; markdown-ts-cjk-fix.el --- Align markdown-ts-mode tables by display width -*- lexical-binding: t; -*-
;;; Commentary:
;; Workaround for bug#81771: https://debbugs.gnu.org/81771
;; upstream で修正されたらこのファイルと init.el の use-package を削除する。
;;; Code:

(require 'cl-lib)
(require 'find-func)
(require 'markdown-ts-mode)

(defun markdown-ts-cjk-fix--table-align-cell (text width align)
  "Return TEXT padded to display WIDTH aligned using ALIGN."
  (let* ((pad (max 0 (- width (string-width text))))
         (left (pcase align ('center (/ pad 2)) ('right pad) (_ 0))))
    (concat (make-string left ?\s) text (make-string (- pad left) ?\s))))

(advice-add 'markdown-ts--table-align-cell :override
            #'markdown-ts-cjk-fix--table-align-cell)

;; 列幅計算は関数内に直書きされていて advice では差し替えられない。
;; defun を丸ごと複製すると upstream の他の修正を取り込めなくなるため、
;; ソースの defun を読み、(length text) を (string-width text) に置換して再定義する。
(let* ((loc (find-function-search-for-symbol
             'markdown-ts-table-align-table nil "markdown-ts-mode"))
       (form (with-current-buffer (car loc)
               (save-excursion (goto-char (cdr loc)) (read (current-buffer)))))
       (patched (cl-subst '(string-width text) '(length text) form :test #'equal)))
  (if (equal form patched)
      (display-warning 'markdown-ts-cjk-fix
                       "置換対象が見つからない。upstream で修正済みか実装が変わった可能性がある")
    (eval patched t)))

(provide 'markdown-ts-cjk-fix)
;;; markdown-ts-cjk-fix.el ends here
