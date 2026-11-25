;;; markdown-ts-table-pad.el --- Pad markdown-ts-mode table cells with spaces -*- lexical-binding: t; -*-
;;; Commentary:
;; markdown-ts-table-align-table の出力を |foo|bar| から | foo | bar | の形式にする。
;;; Code:

(require 'markdown-ts-mode)

;; セル生成関数へ常時 advice すると、区切りセルだけを書き換える
;; markdown-ts-table-align-column 等にも空白が入り二重になるため、整形中に限定する。
(defvar markdown-ts-table-pad--aligning nil)

(defun markdown-ts-table-pad--align-table (f &rest args)
  "Call F with ARGS while padding table cells."
  (let ((markdown-ts-table-pad--aligning t))
    (apply f args)))

;; 列幅 3 未満では区切りが ":" 等になり GFM のテーブルとして解釈されなくなる。
(defun markdown-ts-table-pad--cell-args (args)
  "Widen the width in ARGS of `markdown-ts--table-align-cell' to at least 3."
  (if markdown-ts-table-pad--aligning
      (pcase-let ((`(,text ,width ,align) args))
        (list text (max 3 width) align))
    args))

(defun markdown-ts-table-pad--aligner-args (args)
  "Widen the width in ARGS of `markdown-ts--table-make-aligner' to at least 3."
  (if markdown-ts-table-pad--aligning
      (cons (max 3 (car args)) (cdr args))
    args))

(defun markdown-ts-table-pad--pad (s)
  "Surround S with a space on each side."
  (if markdown-ts-table-pad--aligning (concat " " s " ") s))

(advice-add 'markdown-ts-table-align-table :around #'markdown-ts-table-pad--align-table)

;; markdown-ts-cjk-fix の :override より外側に置かないとフィルタが素通りされる。
(dolist (spec '((markdown-ts--table-align-cell :filter-args markdown-ts-table-pad--cell-args)
                (markdown-ts--table-make-aligner :filter-args markdown-ts-table-pad--aligner-args)
                (markdown-ts--table-align-cell :filter-return markdown-ts-table-pad--pad)
                (markdown-ts--table-make-aligner :filter-return markdown-ts-table-pad--pad)))
  (advice-add (nth 0 spec) (nth 1 spec) (nth 2 spec) '((depth . -90))))

(provide 'markdown-ts-table-pad)
;;; markdown-ts-table-pad.el ends here
