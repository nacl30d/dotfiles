;;; openapi-project.el --- OpenAPI project detection -*- lexical-binding: t; -*-

;;; Commentary:

;; Detects whether a buffer belongs to an OpenAPI project by looking for a
;; root document (openapi.yaml etc.) via dominating-file rather than matching
;; all yaml-ts-mode buffers, to avoid false positives.

;;; Code:

(defvar openapi/root-file-names
  '("openapi.yaml" "openapi.yml" "swagger.yaml" "swagger.yml"))

(defun openapi/root-dir-p (dir)
  (seq-some (lambda (n) (file-exists-p (expand-file-name n dir)))
            openapi/root-file-names))

(defun openapi/openapi-buffer-p (&optional _filename _mode)
  (and (derived-mode-p 'yaml-ts-mode 'yaml-mode)
       buffer-file-name
       (not (file-remote-p buffer-file-name)) ; stat over TRAMP is too costly
       (locate-dominating-file buffer-file-name #'openapi/root-dir-p)
       t))

(provide 'openapi-project)
;;; openapi-project.el ends here
