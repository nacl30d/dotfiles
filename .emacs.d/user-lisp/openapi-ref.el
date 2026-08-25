;;; openapi-ref.el --- OpenAPI $ref jump for yaml-ts-mode -*- lexical-binding: t; -*-

;;; Commentary:

;; yaml-language-server resolves only YAML anchors, not OpenAPI $ref, so
;; $ref <file-path>#<JSON-pointer> is parsed and resolved here.

;;; Code:

(require 'xref)
(require 'openapi-project)

(declare-function lsp-find-definition "lsp-mode")
(defvar yaml-ts-mode-map)

(defun openapi/ref-at-point ()
  (save-excursion
    (beginning-of-line)
    (when (re-search-forward
           "\\$ref\\s-*:\\s-*\\(\"[^\"]*\"\\|'[^']*'\\|[^[:space:]]+\\)"
           (line-end-position) t)
      (replace-regexp-in-string
       "\\`['\"]\\|['\"]\\'" "" (match-string-no-properties 1)))))

(defun openapi/unescape-pointer-token (token)
  ;; RFC6901: decode ~1 before ~0, otherwise ~01 (= "~1") would become "/"
  (replace-regexp-in-string
   "~0" "~" (replace-regexp-in-string "~1" "/" token)))

(defun openapi/block-end-position (start parent-indent)
  ;; negative PARENT-INDENT signals point-max so callers can search the whole buffer
  (if (< parent-indent 0)
      (point-max)
    (save-excursion
      (goto-char start)
      (let ((end (point-max)))
        (catch 'done
          (while (re-search-forward "^\\([ \t]*\\)[^ \t\n#]" nil t)
            (when (<= (- (match-end 1) (match-beginning 1)) parent-indent)
              (setq end (line-beginning-position))
              (throw 'done nil))))
        end))))

(defun openapi/goto-json-pointer (pointer)
  ;; flow-style YAML is not supported; block-style only
  (let ((segments (mapcar #'openapi/unescape-pointer-token
                          (split-string (or pointer "") "/" t)))
        (search-start (point-min))
        (parent-indent -1)
        (target nil)
        (ok t))
    (dolist (seg segments)
      (when ok
        (goto-char search-start)
        (let ((case-fold-search nil)
              (pat (concat "^\\([ \t]*\\)['\"]?"
                           (regexp-quote seg)
                           "['\"]?[ \t]*:"))
              (limit (openapi/block-end-position search-start parent-indent))
              (found nil))
          (while (and (not found) (re-search-forward pat limit t))
            (let ((indent (- (match-end 1) (match-beginning 1))))
              (when (> indent parent-indent)
                (setq found t
                      target (match-beginning 0)
                      parent-indent indent
                      search-start (line-beginning-position 2)))))
          (unless found
            (setq ok nil)
            (message "OpenAPI: key not found in JSON pointer: %s" seg)))))
    (when (and ok target)
      (goto-char target)
      (back-to-indentation))
    (and ok target)))

(defun openapi/jump-to-ref ()
  "Jump to the definition pointed to by the OpenAPI $ref on the current line."
  (interactive)
  (let ((ref (openapi/ref-at-point)))
    (unless ref (user-error "No $ref on this line"))
    (let* ((hash (string-search "#" ref))
           (file (if hash (substring ref 0 hash) ref))
           (pointer (and hash (substring ref (1+ hash))))
           (target-buf
            (if (string-empty-p file)
                (current-buffer)
              (let ((path (expand-file-name
                           file (file-name-directory (buffer-file-name)))))
                (unless (file-exists-p path)
                  (user-error "$ref file not found: %s" path))
                (find-file-noselect path)))))
      (xref-push-marker-stack)
      (unless (eq target-buf (current-buffer))
        (switch-to-buffer target-buf))
      (if (and pointer (not (string-empty-p pointer)))
          (openapi/goto-json-pointer pointer)
        (goto-char (point-min))))))

(defun openapi/find-definition-dwim ()
  "Jump to $ref target on $ref lines; fall back to normal definition search elsewhere."
  (interactive)
  (cond ((openapi/ref-at-point) (openapi/jump-to-ref))
        ((bound-and-true-p lsp-mode) (call-interactively #'lsp-find-definition))
        (t (call-interactively #'xref-find-definitions))))

(with-eval-after-load 'yaml-ts-mode
  (define-key yaml-ts-mode-map (kbd "M-.") #'openapi/find-definition-dwim))

(provide 'openapi-ref)
;;; openapi-ref.el ends here
