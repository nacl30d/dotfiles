;;; markdown-plantuml.el --- Render PlantUML blocks in markdown-live-preview -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'url)

(defcustom markdown-plantuml-jar-path (locate-user-emacs-file "plantuml.jar")
  "Path to plantuml.jar used to render PlantUML blocks in markdown preview."
  :type 'file
  :group 'markdown)

(defcustom markdown-plantuml-jar-url
  "https://github.com/plantuml/plantuml/releases/latest/download/plantuml.jar"
  "URL to download plantuml.jar from. Override to pin a specific version."
  :type 'string
  :group 'markdown)

(defun markdown-plantuml-download-jar ()
  "Download plantuml.jar to `markdown-plantuml-jar-path'."
  (interactive)
  (let ((path (expand-file-name markdown-plantuml-jar-path)))
    (make-directory (file-name-directory path) t)
    (message "Downloading plantuml.jar...")
    (url-copy-file markdown-plantuml-jar-url path t)
    (message "Downloaded plantuml.jar to %s" path)))

(defun markdown-plantuml--ensure-jar ()
  (unless (file-exists-p (expand-file-name markdown-plantuml-jar-path))
    (if (yes-or-no-p (format "plantuml.jar not found at %s. Download it now? "
                             markdown-plantuml-jar-path))
        (markdown-plantuml-download-jar)
      (user-error "Aborted: plantuml.jar not found"))))

(defun markdown-plantuml--render (file)
  "Replace PlantUML code blocks in FILE with inline SVG."
  (markdown-plantuml--ensure-jar)
  (with-temp-buffer
    (insert-file-contents file)
    (while (re-search-forward
            "<pre><code class=\"language-p\\(?:lant\\)?uml\">\\(\\(?:.\\|\n\\)*?\\)</code></pre>"
            nil t)
      (let* ((code (replace-regexp-in-string
                    "&amp;" "&"
                    (replace-regexp-in-string
                     "&lt;" "<"
                     (replace-regexp-in-string "&gt;" ">" (match-string 1)))))
             (src (if (string-prefix-p "@startuml" (string-trim code))
                      code
                    (concat "@startuml\n" code "\n@enduml")))
             (tmpdir (make-temp-file "plantuml" t))
             (puml (expand-file-name "d.puml" tmpdir))
             (svg  (expand-file-name "d.svg"  tmpdir)))
        (with-temp-file puml (insert src))
        (call-process "java" nil nil nil
                      "-jar" (expand-file-name markdown-plantuml-jar-path)
                      "-tsvg" "-o" tmpdir puml)
        (replace-match (with-temp-buffer
                         (insert-file-contents svg)
                         (buffer-string))
                       t t)))
    (write-region (point-min) (point-max) file))
  file)

(advice-add 'markdown-live-preview-export :filter-return #'markdown-plantuml--render)
(advice-add 'markdown-export :filter-return #'markdown-plantuml--render)

(provide 'markdown-plantuml)
;;; markdown-plantuml.el ends here
