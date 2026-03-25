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
         "https://raw.githubusercontent.com/radian-software/straight.el/main/install.el"
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
  :bind ("C-c i" . git-link)
  :config
  (setq git-link-open-in-browser 't))

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
(defun one-line-comment ()
  "Toggle comment out."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (set-mark (point))
    (end-of-line)
    (comment-or-uncomment-region (region-beginning) (region-end))))
(global-set-key (kbd "M-/") 'one-line-comment)

(global-subword-mode)

(use-package editorconfig
  :init
  (editorconfig-mode t))

(use-package corfu
  ;; TAB-and-Go customizations
  :custom
  (corfu-cycle t)           ;; Enable cycling for `corfu-next/previous'
  (corfu-preselect 'prompt) ;; Always preselect the prompt
  ;; Enable auto completion, configure delay, trigger and quitting
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  ;; (corfu-auto-trigger ".") ;; Custom trigger characters
  (corfu-quit-no-match 'separator) ;; or t

  ;; Use TAB for cycling, default is `corfu-complete'.
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous))

  :init
  (global-corfu-mode))

(use-package corfu-terminal
  :if (version< emacs-version "31")
  :after corfu
  :unless (display-graphic-p)
  :config
  (corfu-terminal-mode))

(use-package kind-icon
  :after corfu
  ;:custom
  ; (kind-icon-blend-background t)
  ; (kind-icon-default-face 'corfu-default) ; only needed with blend-background
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (advice-add 'lsp-completion-at-point :around #'cape-wrap-buster)
  (advice-add 'lsp-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add 'lsp-completion-at-point :around #'cape-wrap-noninterruptible)

  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-tex t)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
)

(use-package consult
  :bind
  (("C-s" . consult-line)
   ("C-x b" . consult-buffer)
   ("C-c g" . consult-goto-line)
   ("C-c j" . consult-git-grep)
   ("M-s" . consult-imenu)
   ;; ("C-c o" . consult-outline)
   )
  :init
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(use-package consult-flycheck
  :after (consult flycheck))

;; Enable Vertico.
(use-package vertico
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Configure directory extension.
(use-package vertico-directory
  :after vertico
  :straight (:type built-in)
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("C-h" . vertico-directory-delete-word)
              ("M-DEL" . vertico-directory-delete-word))
  ;; ;; Tidy shadowed file names
  ;; :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))
  )

;; Optionally use the `orderless' completion style.
(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  :init
  (marginalia-mode))

(use-package projectile
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map))
  :config
  (setq projectile-project-search-path ' (("~/Developer" . 1))))

(use-package consult-projectile)

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

(use-package mise
  :init
  (global-mise-mode))

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
  (setq ispell-extra-args '("--camel-case"))
  (setq ispell-dictionary "en_US")
  (with-eval-after-load "ispell"
    (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))
  :hook
  (text-mode . flyspell-mode)
  (prog-mode . flyspell-prog-mode))

(use-package treesit
  :straight (:type built-in)
  :config
  (setq treesit-language-source-alist
        '((astro "https://github.com/virchau13/tree-sitter-astro")
          (bash "https://github.com/tree-sitter/tree-sitter-bash")
          (css "https://github.com/tree-sitter/tree-sitter-css")
          (elisp "https://github.com/Wilfred/tree-sitter-elisp")
          (go "https://github.com/tree-sitter/tree-sitter-go")
          (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
          (graphql "https://github.com/bkegley/tree-sitter-graphql")
          (html "https://github.com/tree-sitter/tree-sitter-html")
          (kotlin "https://github.com/fwcd/tree-sitter-kotlin")
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
  (add-to-list 'major-mode-remap-alist '(sh-mode . bash-ts-mode))
  (add-to-list 'major-mode-remap-alist '(css-mode . css-ts-mode))
  (add-to-list 'major-mode-remap-alist '(js-mode . javascript-ts-mode))
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
  (add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode))
  (add-to-list 'major-mode-remap-alist '(json-mode . json-ts-mode))
  (add-to-list 'major-mode-remap-alist '(toml-mode . toml-ts-mode))
  (add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode))
  (setq treesit-font-lock-level 4))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")

  :config
  ;; with corfu
  (setq lsp-completion-provider :none)

  ;; (setq lsp-log-io t)
  (setq gc-cons-threshold (* 100 1024 1024)
        read-process-output-max (* 1024 1024))
  (setq lsp-signature-auto-activate nil)

  ; JS/TS
  (setq lsp-javascript-preferences-import-module-specifier "relative")
  (setq lsp-typescript-preferences-import-module-specifier "relative")

  ; Kotlin
  (defun kotlin-lsp-server-start-fun (port)
    (list "kotlin-lsp.sh" "--socket" (number-to-string port)))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-tcp-connection 'kotlin-lsp-server-start-fun)
    :activation-fn (lsp-activate-on "kotlin")
    :major-modes '(kotlin-mode kotlin-ts-mode)
    :priority -1
    :server-id 'kotlin-jb-lsp
    ))

  ;; ignore laravel's storage directory
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]storage\\'")

  :hook (
         (astro-ts-mode . lsp)
         (go-ts-mode . lsp)
         (js-ts-mode . lsp)
         (kotlin-ts-mode . lsp)
         (typescript-ts-mode . lsp)
         (tsx-ts-mode . lsp)
         (php-ts-mode . lsp)
         (python-ts-mode . lsp)
         (vue-mode . lsp)
         (bash-ts-mode . lsp)
         (terraform-mode . lsp)
         (graphql-mode . lsp)
         (sql-mode . lsp)
         (json-ts-mode . lsp)
         (toml-ts-mode .lsp)
         (yaml-ts-mode . lsp)
         (toml-ts-mode . lsp)
         (dockerfile-ts-mode . lsp))
  :commands lsp)

(use-package lsp-ui
  :config
  (setq
   lsp-eldoc-render-all t
   lsp-ui-sideline-diagnostic-max-lines 3
   lsp-idle-delay 0.1)
  :commands lsp-ui-mode)

(use-package dap-mode
  :after
  (lsp-mode)
  :config
  (setq dap-auto-configure-features '(sessions locals controls tooltip)))

(use-package csv-mode)

(use-package sql-indent)

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.blade\\.php\\." . web-mode)
         ("\\.astro\\'" . web-mode))
  :config
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-style-padding 2)
  (setq web-mode-script-padding 2)
  (setq web-mode-block-padding 0)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-engines-alist
        ' (("php" . "\\.phtml\\'")
           ("blade" . "\\.blade\\.php\\."))))

(define-derived-mode vue-mode
  web-mode "vue")
(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode))

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

(use-package prisma-mode
  :straight (:host github :repo "pimeys/emacs-prisma-mode" :branch "main"))

(use-package astro-ts-mode)

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

(use-package kotlin-ts-mode
  ;; :straight (:host gitlab :repo "bricka/emacs-kotlin-ts-mode")
  :mode "\\.kts?\\'"
  )

;; (use-package jinja2-mode
;;   :mode (("\\.tpl\\'" . jinja2-mode)))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :config
  (setq markdown-command "cmark-gfm -e table")
  (setq markdown-command-needs-filename t)
  (setq markdown-content-type "application/xhtml+xml")
  (setq markdown-css-paths '("https://cdn.jsdelivr.net/npm/github-markdown-css"))
  (setq markdown-xhtml-body-preamble "<div class='markdown-body'>" )
  (setq markdown-xhtml-body-epilogue "</div>"))

(use-package toml-ts-mode
  :straight (:type built-in)
  :mode (("\\.toml$" . toml-ts-mode))
  )

(use-package yaml-ts-mode
  :straight (:type built-in)
  :mode (("\\.ya?ml$" . yaml-ts-mode))
  :config
  (define-key yaml-ts-mode-map (kbd "C-m") 'newline-and-indent))

(use-package json-ts-mode
  :straight (:type built-in)
  :mode (("\\.jsonc?$" . json-ts-mode))
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

(use-package org
  :bind
  ("C-c c" . org-capture)
  ("C-c a" . org-agenda)
  :config
  ;; Basics
  (setq org-directory "~/org/"
        org-default-notes-file (concat org-directory "index.org")
        org-use-speed-commands t)
  ;; Task Managements
  (setq org-todo-keywords '((sequence
                             "TODO(!)" "NOT STARTED(n!)" "IN PROGRESS(p!)" "WAITING(w!)" "FUTURE(f!)"
                             "|" "DONE(d!)" "DECLINED(x!)"))
        org-todo-keyword-faces '(("TODO" . (:foreground "brightyellow" :weight bold)) ("NOT STARTED" . (:foreground "deeppink" :weight bold))
                                 ("IN PROGRESS" . (:foreground "paleturquoise" :weight bold)) ("WAITING" . (:foreground "lightcyan" :weight bold))
                                 ("FUTURE" . (:foreground "palegoldenrod" :background "darkgray" :weight bold))
                                 ("DONE" . (:foreground "palegreen" :weight bold)) ("DECLINED" . (:foreground "palegreen" :background "darkgray" :weight bold))))
  (setq org-priority-faces '((?A . (:foreground "orangered" :weight bold))
                             (?B . (:foreground "yellowgreen"))
                             (?C . (:foreground "brightblue"))))
  ;; Agenda
  (setq org-agenda-files (directory-files-recursively org-directory "\\.org$")
        org-agenda-window-setup 'current-window
        calendar-holidays nil
        org-refile-targets '((org-agenda-files :maxlevel . 2)))
  (setq org-agenda-sorting-strategy
        '(deadline-up scheduled-up todo-state-up priority-down))
  (setq org-agenda-skip-timestamp-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-scheduled-if-deadline-is-shown t
        org-agenda-skip-timestamp-if-deadline-is-shown t)
  ;; Capture
  (setq org-capture-templates
        '(
          ("t" "Task" entry (file+headline "" "Tasks")
           "* TODO %?\n  %u\n  %a"
           :empty-lines 1)
          ("s" "Sticky note" entry (file+datetree org-default-notes-file)
           "* %U\n%?\n%i\n"
           :empty-lines 1)
          ))
  )


(use-package org-super-agenda
  :after org-agenda
  :config
  (org-super-agenda-mode 1)
  (setq org-super-agenda-groups
        '((:name "Overdue"
                 :deadline past
                 :deadline today
                 :order 1)
          (:name "Scheduled"
                 :scheduled t
                 :order 2)
          (:name "Recursive"
                 :habit t
                 :order 110)
          (:name "NOT Scheduled"
                 :and (:deadline t :scheduled nil)
                 :order 3)
          (:name "Inbox"
                 :todo "TODO"
                 :order 100)
          (:name "Backlog"
                 :todo "FUTURE"
                 :order 120)
          (:name ""
                 :auto-outline-path t
                 :order 10)))
  )

;;----------------------------------------------------------------------------------
;; shell
;;----------------------------------------------------------------------------------
;; (use-package multi-term
;;   :bind ("C-c t" . multi-term)
;;   :config
;;   (setq multi-term-program "/usr/local/bin/zsh")
;;   (delete "C-c" term-unbind-key-list)
;;   (defun term-send-previous-line ()
;;     (interactive)
;;     (term-send-raw-string (kbd "C-p")))
;;   (defun term-send-next-line ()
;;     (interactive)
;;     (term-send-raw-string (kbd "C-n")))
;;   (add-hook 'term-mode-hook
;;             #'(lambda ()
;;                (define-key term-raw-map (kbd "C-p") 'term-send-previous-line)
;;                (define-key term-raw-map (kbd "C-n") 'term-send-next-line))))

;;----------------------------------------------------------------------------------
;; diff
;;----------------------------------------------------------------------------------
(defun command-line-diff (switch)
  "Ediff from command line."
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

(use-package restclient
  :after restclient-jq
  :config
  (setq restclient-enable-eval t)
  :mode ("\\.http\\'" . restclient-mode))
(use-package restclient-jq)

(use-package graphql-mode
  :after request)

(provide 'init)
;;; init.el ends here
