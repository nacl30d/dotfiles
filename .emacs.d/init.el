
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq load-path (cons "~/.emacs.d/elisp" load-path))

(setq debug-on-error t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; encoding
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; language
(set-locale-environment nil)
(set-language-environment 'utf-8)

;; theme
(load-theme 'srcery t)

(setq inhibit-startup-message t)
(setq-default tab-width 4 indent-tabs-mode nil)
(setq completion-ignore-case t)
(global-auto-revert-mode 1)
(global-linum-mode t)
(setq linum-format "%d ")
(column-number-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq vc-follow-symlinks t)

;; highlights
(show-paren-mode t)
(require 'hiwin)            ;change background color if active window or not
(hiwin-activate)
(set-face-background 'hiwin-face "gray50")
(require 'hl-line+)
(global-set-key (kbd "C-x c") 'flash-line-highlight)
(set-face-background 'hl-line "yellow")

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

;; auto-complete
(require 'auto-complete)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)
(add-to-list 'ac-modes 'fundamental-mode)
(add-to-list 'ac-modes 'latex-mode)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)
(setq ac-use-fuzzy t)

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

;; key bainds
(global-set-key (kbd "C-x :") 'goto-line)

;; assign meta key to option key on Mac
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta)
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

;; TeX mode
(setq auto-mode-alist
      (append '(("\\.tex$" . latex-mode)) auto-mode-alist))
(setq tex-default-mode 'latex-mode)
(setq tex-start-commands "\\nonstopmode\\input")
(setq tex-run-command "ptex2pdf -u -e -ot '-synctex=1 -interaction=nonstopmode'")
(setq latex-run-command "ptex2pdf -u -l -ot '-synctex=1 -interaction=nonstopmode'")
(setq tex-bibtex-command "latexmk -norc -gg -pdfdvi")
(setq tex-print-file-extension ".pdf")
(setq tex-dvi-view-command "open -a /Applications/Skim.app")
(setq tex-dvi-print-command "open -a /Applications/Preview.app")
(setq tex-compile-commands
      '(("ptex2pdf -u -l -ot '-synctex=1 -interaction=nonstopmode' %f" "%f" "%r.pdf")
        ("latexmk %f" "%f" "%r.pdf")
        ("latexmk -norc -gg -pdfdvi %f" "%f" "%r.pdf")
        ("latexmk -norc -gg -pdflua %f" "%f" "%r.pdf")
        ((concat "\\doc-view" " \"" (car (split-string (format "%s" (tex-main-file)) "\\.")) ".pdf\"") "%r.pdf")
        ("open -a /Applications/Skim.app %r.pdf" "%r.pdf")
        ("open -a /Applications/Preview %r.pdf" "%r.pdf")
        ("open -a \"Google Chrome\" %r.pdf" "%r.pdf")))

(defun skim-forward-search ()
  (interactive)
  (let* ((ctf (buffer-name))
         (mtf (tex-main-file))
         (pf (concat (car (split-string mtf "\\.")) ".pdf"))
         (ln (format "%d" (line-number-at-pos)))
         (cmd "/Applications/Skim.app/Contents/SharedSupport/displayline")
         (args (concat ln " " pf " " ctf)))
    (message (concat cmd " " args))
    (process-=query-on-exit-flag
     (start-process-shell-command "displayline" nil cmd args))))

(add-hook 'latex-mode-hook
          '(lambda ()
             (define-key latex-mode-map (kbd "C-c s") 'skim-forward-search)))

;; RefTeX with TeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex)

;; magit
(global-set-key (kbd "C-x g") 'magit-status)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (hiwin auto-complete magit markdown-mode srcery-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
