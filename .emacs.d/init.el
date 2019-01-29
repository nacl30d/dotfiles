;;; init.el --- my init el
;;; commentary:

;; prerequirements
;;   - git for package, magit
;;   - mozc for input method
;;   - lints for flycheck


;;; Code:

(setq debug-on-error t)

;;----------------------------------------------------------------------------------
;; straight.el
;;----------------------------------------------------------------------------------

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)


;;----------------------------------------------------------------------------------
;; Encoding and Language
;;----------------------------------------------------------------------------------
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(set-locale-environment nil)
(set-language-environment 'utf-8)


;;----------------------------------------------------------------------------------
;; Input method
;;----------------------------------------------------------------------------------
(use-package mozc
  :init
  (defvar mozc-helper-program-name "mozc_emacs_helper")
  (setq default-input-method "japanese-mozc")
  (custom-set-variables '(mozc-leim-title "あ"))
  :config
  (set-cursor-color "cyan")
  (add-hook 'input-method-activate-hook
            (lambda () (set-cursor-color "masenta")))
  (add-hook 'input-method-inactivate-hook
            (lambda () (set-cursor-color "cyan"))))

(use-package mozc-popup
  :config
  (defvar mozc-candidate-style 'popup))


;;----------------------------------------------------------------------------------
;; basics
;;----------------------------------------------------------------------------------
(setq-default tab-width 4 indent-tabs-mode nil)
(setq completion-ignore-case t)
(global-auto-revert-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(setq backup-directory-alist            ;backup file dir
      (cons (cons ".*" (expand-file-name "~/.emacs.d/.backup/"))
            backup-directory-alist))
(setq auto-save-file-name-transforms    ;auto-save file dir
      `((".*", (expand-file-name "~/.emacs.d/.backup/") t)))
(setq auto-save-list-file-prefix "~/.emacs.d/.backup/auto-save-list/.saves-")


;;----------------------------------------------------------------------------------
;; mode line
;;----------------------------------------------------------------------------------
(defface egoge-display-time
  '((((type tty))
       (:foreground "blue")))
  "Face used to display the time in the mode line.")
(defvar display-time-string-forms
      '((propertize (concat " " monthname " " day " " 24-hours ":" minutes " ")
                    'face 'egoge-display-time)))
(display-time-mode t)
(global-linum-mode t)
(defvar linum-format "%d ")
(column-number-mode t)


;;----------------------------------------------------------------------------------
;; version control system
;;----------------------------------------------------------------------------------
(setq vc-follow-symlinks t)
(use-package magit
  :bind ("C-x g" . magit-status))



;;----------------------------------------------------------------------------------
;; views
;;----------------------------------------------------------------------------------
(show-paren-mode t)                     ;highlight paren pairs
(menu-bar-mode -1)                      ;hidden menu bar
(setq inhibit-startup-message t)        ;hidden startup msg
(global-set-key (kbd "C-x p") '(lambda () (interactive)(other-window -1))) ;reverse windo

(use-package srcery-theme               ;theme
  :init
  (load-theme 'srcery t))

(use-package hiwin                      ;change background color if active window or not
  :init
  (hiwin-activate)
  :config
  (set-face-background 'hiwin-face "gray50"))

(use-package hl-line+                   ;flash cursor line
  :bind ("C-x C-h" . flash-line-highlight)
  :config
  (set-face-background 'hl-line "yellow"))

(use-package whitespace                ;white spaces
  :bind ("C-x w" . global-whitespace-mode)
  :init
  (global-whitespace-mode 1)
  :config
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
  (set-face-bold-p     'whitespace-space t))


;;----------------------------------------------------------------------------------
;; edit
;;----------------------------------------------------------------------------------
(global-set-key (kbd "C-c g") 'goto-line) ;goto line
(defun one-line-comment ()
  "Toggle comment out."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (set-mark (point))
    (end-of-line)
    (comment-or-uncomment-region (region-beginning) (region-end))))
(global-set-key (kbd "M-/") 'one-line-comment)

(use-package auto-complete              ;complement
  :init
  (ac-config-default)
  :config
  (add-to-list 'ac-modes 'text-mode)
  (add-to-list 'ac-modes 'fundamental-mode)
  (add-to-list 'ac-modes 'latex-mode)
  (add-to-list 'ac-modes 'markdown-mode)
  (ac-set-trigger-key "TAB")
  (setq ac-use-menu-map t)
  (setq ac-use-fuzzy t)
  (setq ac-comphist-file "~/.emacs.d/.cache/auto-complete/ac-comphist.dat"))

(use-package undo-tree
  :init
  (global-undo-tree-mode))

(use-package flycheck
  :init
  (global-flycheck-mode))

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode))
  :config
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-style-padding 1)
  (setq web-mode-script-padding 1)
  (setq web-mode-block-padding 0)
  (setq web-mode-enable-css-colorization t))

(use-package js2-mode
  :mode (("\\.js\\'" . js2-mode)))

(use-package php-mode
  :mode (("\\.php\\'" . php-mode)))

(use-package markdown-mode
  :commands (markdown-mode)
  :mode (("\\.md\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown"))


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
  "Skim search function."
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



;;----------------------------------------------------------------------------------
;; shell
;;----------------------------------------------------------------------------------
(use-package multi-term
  :bind ("C-c t" . multi-term)
  :config
  (setq multi-term-program "/usr/local/bin/zsh")
  (delete "C-c" term-unbind-key-list)
  (defun term-send-previous-line ()
    (interactive)
    (term-send-raw-string (kbd "C-p")))
  (defun term-send-next-line ()
    (interactive)
    (term-send-raw-string (kbd "C-n")))
  (add-hook 'term-mode-hook
            '(lambda ()
               (define-key term-raw-map (kbd "C-p") 'term-send-previous-line)
               (define-key term-raw-map (kbd "C-n") 'term-send-next-line))))

(provide 'init)
;;; init.el ends here
