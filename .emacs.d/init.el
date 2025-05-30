;;; init.el --- my init el
;;; commentary:

;; prerequirements
;;   - git for package, magit
;;   - mozc for input method
;;   - lints for flycheck


;;; Code:

;; (setq debug-on-error t)

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
;; (use-package mozc
;;  :init
;;  (defvar mozc-helper-program-name "mozc_emacs_helper")
;;  (setq default-input-method "japanese-mozc")
;;  (custom-set-variables '(mozc-leim-title "あ"))
;;  :config
;;  (set-cursor-color "cyan")
;;  (add-hook 'input-method-activate-hook
;;            (lambda () (set-cursor-color "masenta")))
;;  (add-hook 'input-method-inactivate-hook
;;            (lambda () (set-cursor-color "cyan"))))

;; (use-package mozc-popup
;;  :config
;;  (defvar mozc-candidate-style 'popup))
;; (use-package ac-mozc
;;  :init
;;  (bind-keys :map ac-mode-map
;;             ("C-c C-SPC" . ac-complete-mozc))
;;  (add-hook 'after-change-major-mode-hook 'ac-mozc-mode)
;;  :config
;;  (defun ac-mozc-mode ()                ; Enable ac-mozc-mode if not latex mode.
;;    (unless (eq major-mode 'latex-mode)
;;      (add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p nil t)))
;;  (defun ac-mozc-setup ()               ; See <https://github.com/igjit/ac-mozc>
;;    (setq ac-sources
;;          '(ac-source-mozc ac-source-ascii-words-in-same-mode-buffers))
;;    (set (make-local-variable 'ac-auto-show-menu) 0.2)))

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
(setq backup-by-copying t)

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
(global-display-line-numbers-mode)
(defvar linum-format "%d ")
(column-number-mode t)


;;----------------------------------------------------------------------------------
;; version control system
;;----------------------------------------------------------------------------------
(setq vc-follow-symlinks t)

(use-package magit
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-completing-read-function 'ivy-completing-read))

(use-package forge
  :after magit
  :config
  (setq auth-sources '("~/.authinfo.gpg")))

(use-package git-modes)

(use-package git-link
  :config
  (setq git-link-open-in-browser 't))
(global-set-key (kbd "C-c i") 'git-link)

(use-package git-gutter
  :init
  (global-git-gutter-mode t)
)

(use-package difftastic
  :defer t
  :config (difftastic-bindings-mode))

;;----------------------------------------------------------------------------------
;; views
;;----------------------------------------------------------------------------------
(show-paren-mode t)                     ;highlight paren pairs
(menu-bar-mode -1)                      ;hidden menu bar
(setq inhibit-startup-message t)        ;hidden startup msg
(global-set-key (kbd "C-x p") #'(lambda () (interactive)(other-window -1))) ;reverse windo
(tab-bar-mode 1)
(which-key-mode 1)

(use-package window-numbering
  :init
  (window-numbering-mode 1))

(use-package dracula-theme               ;theme
  :init
  (load-theme 'dracula t))

(use-package hiwin                      ;change background color if active window or not
  :init
  (hiwin-activate)
  :config
  (set-face-background 'hiwin-face "gray50"))

;; (use-package hl-line+                   ;flash cursor line
;;   :bind ("C-x C-h" . flash-line-highlight)
;;   :config
;;   (set-face-background 'hl-line "yellow"))

(use-package whitespace                ;white spaces
  :bind ("C-x w" . global-whitespace-mode)
  :init
  (global-whitespace-mode 1)
  :config
  (setq whitespace-style '(face trailing tabs tab-mark spaces space-mark))
  (setq whitespace-display-mappings
        '((space-mark ?\u3000 [?\u25a1])
          (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-attribute 'whitespace-trailing nil
                      :foreground "#7cfc00"
                      :underline t)
  (set-face-attribute 'whitespace-space nil
                      :foreground "#7cfc00"
                      :weight 'bold)
  (set-face-attribute 'whitespace-tab nil
                      :foreground "#adff2f"
                      :underline t))

(use-package treemacs
  :bind
  (:map global-map
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))

  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always))

(use-package treemacs-nerd-icons
  :after (treemacs)
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package treemacs-icons-dired
  :after (treemacs dired)
  :config
  (treemacs-icons-dired-mode))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :config (treemacs-project-follow-mode))

(use-package treemacs-magit
  :after (treemacs magit))

(use-package treemacs-tab-bar
  :after (treemacs)
  :config (treemacs-set-scope-type 'Tabs))

(use-package imenu-list
  :bind ("C-c '" . imenu-list-smart-toggle)
  :config (setq imenu-list-focus-after-activation t
                imenu-list-auto-resize t))

;;----------------------------------------------------------------------------------
;; edit
;;----------------------------------------------------------------------------------
(global-set-key (kbd "C-h") 'delete-backward-char)
(keyboard-translate ?\C-h ?\C-?)
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

(use-package editorconfig
  :init
  (editorconfig-mode t))

(use-package company
  :init
  (global-company-mode)
  :bind(:map company-active-map
             ("<return>" . nil)
             ("RET" . nil)
             ("<tab>" . company-complete-selection)
             ("TAB" . company-complete-selection))
  :config
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1))

(use-package swiper)
(use-package counsel)
(use-package ivy
  :init
  (ivy-mode)
  :bind
  ;; ("C-s" . isearch-forward-or-swiper)
  ("C-s" . swiper-isearch)
  ("M-s" . counsel-imenu)
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("C-c j" . counsel-git-grep)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-count-format "(%d/%d) "))

(use-package projectile
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map))
  :config
  (setq projectile-project-search-path ' (("~/Developer" . 1))))
(use-package counsel-projectile
  :defer t
  :init (counsel-projectile-mode t))
  ;; :bind (("C-c p" . projectile-command-map)))

(use-package undo-tree
  :init
  (global-undo-tree-mode)
  :config
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

(use-package hl-todo
  :init
  (global-hl-todo-mode)
  :config
  (setq hl-todo-keyword-faces
        '(("HOLD" . "#d0bf8f")
          ("TODO" . "#cc9393")
          ("NEXT" . "#dca3a3")
          ("THEM" . "#dc8cc3")
          ("PROG" . "#7cb8bb")
          ("OKAY" . "#7cb8bb")
          ("DONT" . "#5f7f5f")
          ("FAIL" . "#8c5353")
          ("DONE" . "#afd8af")
          ("NOTE"   . "#d0bf8f")
          ("KLUDGE" . "#d0bf8f")
          ("HACK"   . "#d0bf8f")
          ("TEMP"   . "#d0bf8f")
          ("FIXME"  . "#cc9393")
          ("WATCH"  . "#ff459a")
          ("XXX+"   . "#cc9393")))
  )

;; (use-package flycheck-popup-tip)

(use-package exec-path-from-shell
  :config
  (setq exec-path-from-shell-arguments nil)
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package flycheck
  :init
  (global-flycheck-mode)
  :config
  (setq flycheck-display-errors-delay 0.1)
  (setq-default flycheck-disabled-checkers '(javascript-jshint))
  (setq flycheck-javascript-standard-executable "semistandard")
  (setq flycheck-phpcs-standard  "PSR12")
  (flycheck-add-mode 'html-tidy 'web-mode)
  (flycheck-add-mode 'javascript-standard 'web-mode)
  (flycheck-add-mode 'javascript-standard 'js2-mode))
  ;; :hook
  ;; (flycheck-mode . flycheck-popup-tip-mode))

(use-package flyspell
  :config
  (setq-default ispell-program-name "aspell")
  (setq ispell-dictionary "en_US")
  (with-eval-after-load "ispell"
    (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))
  :hook
  (text-mode . flyspell-mode)
  (prog-mode . flyspell-prog-mode))

(use-package treesit
  :straight (:type built-in)
  :init
  (setq treesit-language-source-alist
        '((bash "https://github.com/tree-sitter/tree-sitter-bash")
          (css "https://github.com/tree-sitter/tree-sitter-css")
          (elisp "https://github.com/Wilfred/tree-sitter-elisp")
          (go "https://github.com/tree-sitter/tree-sitter-go")
          (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
          (html "https://github.com/tree-sitter/tree-sitter-html")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (make "https://github.com/alemuller/tree-sitter-make")
          (markdown "https://github.com/ikatyang/tree-sitter-markdown")
          (python "https://github.com/tree-sitter/tree-sitter-python")
          (toml "https://github.com/tree-sitter/tree-sitter-toml")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
          (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
  (mapc (lambda (lang)
          (unless (treesit-language-available-p lang nil)
            (treesit-install-language-grammar lang)))
        (mapcar #'car treesit-language-source-alist))
  :config
  (add-to-list 'major-mode-remap-alist '(sh-mode . bash-ts-mode))
  (add-to-list 'major-mode-remap-alist '(css-mode . css-ts-mode))
  (add-to-list 'major-mode-remap-alist '(js-mode . javascript-ts-mode))
  (add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode))
  (add-to-list 'major-mode-remap-alist '(json-mode . json-ts-mode))
  (add-to-list 'major-mode-remap-alist '(toml-mode . toml-ts-mode))
  (add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode))
  (setq treesit-font-lock-level 4))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")

  :config
  ;; (setq lsp-log-io t)
  (setq gc-cons-threshold (* 100 1024 1024)
        read-process-output-max (* 1024 1024))
  (setf lsp-prefer-capf t)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-javascript-preferences-import-module-specifier "relative")
  (setq lsp-typescript-preferences-import-module-specifier "relative")

  (with-eval-after-load 'lsp-mode
    ; ignore laravel's storage directory
    (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]storage\\'"))
  :hook (
         (go-ts-mode . lsp)
         (js-ts-mode . lsp)
         (typescript-ts-mode . lsp)
         (tsx-ts-mode . lsp)
         (php-ts-mode . lsp)
         (python-mode . lsp)
         (bash-ts-mode . lsp)
         (terraform-mode . lsp)
         (sql-mode . lsp)
         (json-ts-mode . lsp)
         (yaml-ts-mode . lsp)
         (dockerfile-ts-mode . lsp))
  :commands lsp)

(use-package lsp-ui
  :config
  (setq
   lsp-eldoc-render-all t
   lsp-ui-sideline-diagnostic-max-lines 3
   lsp-idle-delay 0.1)
  :commands lsp-ui-mode)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package dap-mode
  :after
  (lsp-mode)
  :config
  (setq dap-auto-configure-features '(sessions locals controls tooltip)))

(use-package sql-indent)

;; (use-package web-mode
;;   :mode (("\\.html?\\'" . web-mode)
;;          ("\\.blade\\.php\\." . web-mode)
;;          ("\\.astro\\'" . web-mode))
;;   :config
;;   (setq web-mode-enable-auto-closing t)
;;   (setq web-mode-enable-auto-pairing t)
;;   (setq web-mode-markup-indent-offset 2)
;;   (setq web-mode-css-indent-offset 2)
;;   (setq web-mode-code-indent-offset 2)
;;   (setq web-mode-style-padding 2)
;;   (setq web-mode-script-padding 2)
;;   (setq web-mode-block-padding 0)
;;   (setq web-mode-enable-css-colorization t)
;;   (setq web-mode-engines-alist
;;         ' (("php" . "\\.phtml\\'")
;;            ("blade" . "\\.blade\\.php\\."))))

(use-package js-ts-mode
  :straight (:type built-in)
  :mode (("\\.js\\'" . js-ts-mode)
         ("\\.cjs\\'" . js-ts-mode)
         ("\\.mjs\\'" . js-ts-mode))
  :config
  ;; (setq js2-strict-missing-semi-warning nil)
  ;; (setq js2-missing-semi-one-line-override nil)
  (setq js2-basic-offset 2))

;; (use-package rjsx-mode
;;   :mode (("\\.js\\'" . rjsx-mode))
;;   )

(use-package pnpm-mode)

(use-package typescript-ts-mode
  :straight (:type built-in)
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :config
  (setq-default typescript-indent-level 2))

;; (use-package tide
;;   :after (typescript-mode company flycheck)
;;   :config
;;   :hook ((typescript-mode . tide-setup)
;;          (typescript-mode . tide-hl-identifier-mode)
;;          (tide-mode . eldoc-mode)
;;          (before-save . tide-format-before-save)))

(use-package php-ts-mode
  :straight (:type built-in)
  :mode (("\\.php\\'" . php-ts-mode))
  :config
  (subword-mode 1)
  (setq-local show-trailing-whitespace t)
  (setq-local ac-disable-faces '(font-lock-comment-face font-lock-string-face))
  (add-hook 'hack-local-variables-hook 'php-ide-turn-on nil t)
  (custom-set-variables
   '(php-mode-coding-style 'psr2)
   '(php-mode-template-compatibility nil)
   '(php-imenu-generic-expression 'php-imenu-generic-expression-simple))
  (setq page-delimiter "\\_<\\(class\\|function\\|namespace\\)\\_>.+$")
  :hook
  ((php-mode . php-enable-psr2-coding-style)))

(use-package go-ts-mode
  :config (setq gofmt-command "goimports"))

(use-package go-eldoc
  :config (setq go-eldoc-gocode "gopls")
  :hook ((go-ts-mode . go-eldoc-setup)))

(use-package terraform-mode)

;; (use-package jinja2-mode
;;   :mode (("\\.tpl\\'" . jinja2-mode)))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :init
  (setq markdown-command "github-markup")
  :config
  (setq markdown-command-needs-filename t)
  (setq markdown-content-type "application/xhtml+xml")
  (setq markdown-css-paths '("https://cdn.jsdelivr.net/npm/github-markdown-css"))
  (setq markdown-xhtml-body-preamble "<div class='markdown-body'>" )
  (setq markdown-xhtml-body-epilogue "</div>"))

(use-package yaml-ts-mode
  :straight (:type built-in)
  :mode (("\\.ya?ml$" . yaml-ts-mode))
  :config
  (define-key yaml-ts-mode-map (kbd "C-m") 'newline-and-indent))

(use-package json-ts-mode
  :straight (:type built-in)
  :mode (("\\.json$" . json-mode))
  :config
  (setq js-indent-level 4))

(use-package docker
  :bind ("C-c d" . docker))

(use-package dockerfile-ts-mode
  :straight (:type built-in)
  :mode (("Dockefile\\'" . dockerfile-mode)))

(use-package docker-compose-mode)

(use-package elpy
  :init
  (elpy-enable)
  ;; (elpy-rpc--install-dependencies)
  :config
  (remove-hook 'elpy-modules 'elpy-module-flymake)
  (setq elpy-rpc-python-command "python3")
  (setq flycheck-python-flake8-executable "flake8")
  :hook
  (elpy-mode . flycheck-mode)
  )

(use-package poetry
  :hook
  (elpy-mode . poetry-tracking-mode))

(use-package py-isort
  :hook
  (before-save . py-isort-before-save))

(use-package nginx-mode
  :mode (("nginx.conf\\'" . nginx-mode)))

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
          #'(lambda ()
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
            #'(lambda ()
               (define-key term-raw-map (kbd "C-p") 'term-send-previous-line)
               (define-key term-raw-map (kbd "C-n") 'term-send-next-line))))

(provide 'init)


;;----------------------------------------------------------------------------------
;; diff
;;----------------------------------------------------------------------------------
(defun command-line-diff (switch)
  "Ediff from ommand line."
  (let ((file1 (pop command-line-args-left))
        (file2 (pop command-line-args-left)))
    (ediff file1 file2)))

;; Usage: emacs -diff file1 file2
(add-to-list 'command-switch-alist '("diff" . command-line-diff))

(add-hook 'ediff-load-hook
          (lambda ()
            (set-face-foreground
             ediff-current-diff-face-A "Black")
            (set-face-background
             ediff-current-diff-face-A "Green")
            (set-face-foreground
             ediff-fine-diff-face-A "White")
            (make-face-bold
             ediff-fine-diff-face-A)
            (set-face-background
             ediff-fine-diff-face-A "Green")
            (set-face-background
             ediff-odd-diff-face-A "PaleGreen")
            (set-face-foreground
             ediff-odd-diff-face-A "Black")
            (set-face-foreground
             ediff-current-diff-face-B "Black")
            (set-face-background
             ediff-current-diff-face-B "Red")
            (set-face-foreground
             ediff-fine-diff-face-B "Black")
            (make-face-bold
             ediff-fine-diff-face-B)
            (set-face-background
             ediff-fine-diff-face-B "Red")
            (set-face-background
             ediff-odd-diff-face-B "Pink")
            (set-face-foreground
             ediff-odd-diff-face-B "Black")
            (set-face-background
             ediff-odd-diff-face-A "PaleGreen")
            (set-face-foreground
             ediff-odd-diff-face-A "Black")
            (set-face-background
             ediff-even-diff-face-B "Pink")
            (set-face-foreground
             ediff-even-diff-face-B "Black")
            (set-face-background
             ediff-even-diff-face-A "PaleGreen")
            (set-face-foreground
             ediff-even-diff-face-A "Black")
            ))

(setq ediff-split-window-function 'split-window-horizontally)
;;; init.el ends here
