;; encoding
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; language
(set-locale-environment nil)
(set-language-environment "Japanese")


(setq ingibit-startup-message t)
(setq-default tab-width 4 indent-tabs-mode nil)
(global-linum-mode t)
(column-number-mode t)
(show-paren-mode t)
(fset 'yes-or-no-p 'y-or-n-p)

;; white space
(require 'whitespace)
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
(setq whitespace-space-regexp "\\(\u3000+\\)")
(set-face-foreground 'whitespace-tab "#adff2f")
(set-face-background 'whitespace-tab 'nil)
(set-face-underline  'whitespace-tab t)
(set-face-foreground 'whitespace-space "#7cfc00")
(set-face-background 'whitespace-space 'nil)
(set-face-bold-p     'whitespace-space t)
(global-whitespace-mode 1)
(global-set-key (kbd "C-x w") 'global-whitespace-mode)

;; backup file
(setq backup-directory-alist
      (cons (cons ".*" (expand-file-name "~/.emacs.d/backup/"))
            backup-directory-alist
      )
      )

;; auto-save file
(setq auto-sava-file-name-transforms
      '((".*", (expand-file-name "~/.emacs.d/backup/")) t)
)

;; assign meta key to option key on Mac
(when (eq system-type 'darwin)
  (setq mac-option-modifire 'meta)
)

;; change cursor color when jspanese input mode
;; (when (fboundp 'mac-input-source)
;;   (defun change-cursor ()
;;     (let ((mac-input-source (mac-input-source)))
;;       (set-cursor-color (if (string-match "\\.US$" mac-input-source) "Yellow" "Red"))
;;     )
;;   )
;;   (add-hook 'mac-selected-keyboard-input-source-change-hook
;;             'change-cursor)
;; )
