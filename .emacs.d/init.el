;;; init.el --- my init el -*- lexical-binding: t; -*-
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
(setopt straight-use-package-by-default t)


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
;; Input Method
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
;; Basics
;;----------------------------------------------------------------------------------
(setopt tab-width 4 indent-tabs-mode nil)
(global-auto-revert-mode 1)
(setopt use-short-answers t)
(setopt backup-directory-alist          ;backup file dir
        (cons (cons ".*" (expand-file-name "~/.emacs.d/.backup/"))
              backup-directory-alist))
(setopt auto-save-file-name-transforms  ;auto-save file dir
        `((".*", (expand-file-name "~/.emacs.d/.backup/") t)))
(setopt auto-save-list-file-prefix "~/.emacs.d/.backup/auto-save-list/.saves-")
(setopt backup-by-copying t)

(use-package recentf
  :straight (:type built-in)
  :custom
  (recentf-max-saved-items 32)
  :config
  (recentf-mode))

(setopt gc-cons-percentage 0.2
        gc-cons-threshold (* 128 1024 1024))
(use-package so-long
  :init
  (global-so-long-mode))

;;----------------------------------------------------------------------------------
;; Mode Line
;;----------------------------------------------------------------------------------
(defface egoge-display-time
  '((((type tty))
     (:foreground "blue")))
  "Face used to display the time in the mode line.")
(setopt display-time-string-forms
        '((propertize (concat " " monthname " " day " " 24-hours ":" minutes " ")
                      'face 'egoge-display-time)))
(display-time-mode t)
(global-display-line-numbers-mode)
(column-number-mode t)

;;----------------------------------------------------------------------------------
;; Version Control System
;;----------------------------------------------------------------------------------
(setopt vc-follow-symlinks t)

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package git-modes
  :mode (("\\.gitconfig" . gitconfig-mode)
         ("\\.gitignore" . gitignore-mode)))

(use-package forge
  :after magit
  :custom
  (auth-sources '("~/.authinfo.gpg")))

(use-package git-link
  :bind ("C-c i" . git-link)
  :custom
  (git-link-open-in-browser t))

(use-package git-gutter
  :hook (find-file-hook . git-gutter-mode))

(use-package difftastic
  :defer t
  :config (difftastic-bindings-mode))

;;----------------------------------------------------------------------------------
;; Views
;;----------------------------------------------------------------------------------
(show-paren-mode t)
(use-package elec-pair
  :straight (:type built-in)
  :config
  (electric-pair-mode))

(use-package which-key
  :straight (:type built-in)
  :defer 1
  :config
  (which-key-mode))

(use-package tab-bar
  :init
  (tab-bar-mode 1)
  :custom
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  (tab-bar-tab-hints t)
  (tab-bar-auto-width nil)
  (tab-bar-separator " ")
  (tab-bar-format '(tab-bar-format-tabs-groups)))

(use-package tab-line
  :bind
  ;; (("C-<backtab>" . tab-line-switch-to-prev-tab)
  ;;  ("C-<tab>" . tab-line-switch-to-next-tab))
  :init
  (global-tab-line-mode 1)
  :custom
  (tab-line-new-button-show nil)
  (tab-line-close-button-show nil))

(use-package winum
  :init
  (winum-mode))

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
  :custom
  (whitespace-style '(face trailing tabs tab-mark spaces space-mark))
  (whitespace-display-mappings
   '((space-mark ?\u3000 [?\u25a1])
     (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
  (whitespace-space-regexp "\\(\u3000+\\)")
  :config
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
  :custom
  (imenu-list-focus-after-activation t)
  (imenu-list-auto-resize t))

;;----------------------------------------------------------------------------------
;; Edit
;;----------------------------------------------------------------------------------
(use-package simple
  :straight (:type built-in)
  :config
  (normal-erase-is-backspace-mode 1))
(define-key key-translation-map [?\C-h] [?\C-?])
(defun one-line-comment ()
  "Toggle comment out."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (set-mark (point))
    (end-of-line)
    (comment-or-uncomment-region (region-beginning) (region-end))))
(global-set-key (kbd "M-/") 'one-line-comment)

(use-package subword
  :straight (:type built-in)
  :init
  (global-subword-mode))

(use-package editorconfig
  :init
  (editorconfig-mode t))

(use-package vundo
  :commands vundo)

(use-package hl-todo
  :defer 1
  :custom
  (hl-todo-keyword-faces
   '(("HOLD"   . "#d0bf8f")
     ("TODO"   . "#cc9393")
     ("NEXT"   . "#dca3a3")
     ("THEM"   . "#dc8cc3")
     ("PROG"   . "#7cb8bb")
     ("OKAY"   . "#7cb8bb")
     ("DONT"   . "#5f7f5f")
     ("FAIL"   . "#8c5353")
     ("DONE"   . "#afd8af")
     ("NOTE"   . "#d0bf8f")
     ("KLUDGE" . "#d0bf8f")
     ("HACK"   . "#d0bf8f")
     ("TEMP"   . "#d0bf8f")
     ("FIXME"  . "#cc9393")
     ("WATCH"  . "#ff459a")
     ("XXX+"   . "#cc9393")))
  :config
  (global-hl-todo-mode))

;;----------------------------------------------------------------------------------
;; Completion
;;----------------------------------------------------------------------------------
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
  ;; projectile が C-c p を使うため、cape は C-c P に割り当てて衝突を回避する。
  :bind ("C-c P" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (advice-add 'lsp-completion-at-point :around #'cape-wrap-nonexclusive)

  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-tex t)
  (add-hook 'completion-at-point-functions #'tempel-complete)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
)

;; Configure Tempel
(use-package tempel
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert))
  :defer 1
  :config
  (global-tempel-abbrev-mode))

(use-package tempel-collection
  :after tempel)

(use-package consult
  :bind
  (("C-s" . consult-line)
   ("C-x b" . consult-buffer)
   ("C-c g" . consult-goto-line)
   ("C-c j" . consult-git-grep)
   ("M-s" . consult-imenu)
   ;; ("C-c o" . consult-outline)
   )
  :custom
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref))

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

;;----------------------------------------------------------------------------------
;; Project
;;----------------------------------------------------------------------------------
(use-package projectile
  :hook (emacs-startup . projectile-mode)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map))
  :custom
  (projectile-project-search-path '(("~/Developer" . 1))))

(use-package consult-projectile
  :after projectile
  :bind (:map projectile-command-map
              ("p" . consult-projectile)))

;; (use-package flycheck-popup-tip)

;;----------------------------------------------------------------------------------
;; Environment
;;----------------------------------------------------------------------------------
(use-package exec-path-from-shell
  :custom
  (exec-path-from-shell-arguments nil)
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package mise
  :init
  (global-mise-mode))

;;----------------------------------------------------------------------------------
;; Syntax Checking
;;----------------------------------------------------------------------------------
(use-package flycheck
  :init
  (global-flycheck-mode)
  :custom
  (flycheck-display-errors-delay 0.1)
  (flycheck-disabled-checkers '(javascript-jshint))
  (flycheck-javascript-standard-executable "semistandard")
  (flycheck-phpcs-standard "PSR12")
  :config
  (flycheck-add-mode 'html-tidy 'web-mode)
  (flycheck-add-mode 'javascript-standard 'web-mode)
  (flycheck-add-mode 'javascript-standard 'js-ts-mode))
  ;; :hook
  ;; (flycheck-mode . flycheck-popup-tip-mode))

(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages))
  :custom
  (jinx-languages "en_US")
  :config
  ;; Ignore non-English words.
  (add-to-list 'jinx-exclude-regexps '(t ".*[^[:ascii:]].*"))
  ;; flycheck の波線と区別するためドット下線 + 別色を使用する
  (set-face-attribute 'jinx-misspelled nil
                      :underline '(:style dots :color "orange"))
  ;; jinx--timer-handler が update 引数なしの (window-end) を渡すため、
  ;; 他パッケージによる narrowing・バッファ縮小直後に stale な値が
  ;; point-max を超え args-out-of-range となる (cf. gh:minad/jinx#266)。
  ;; upstream は jinx 外の相互作用とみなし修正を入れていないため、
  ;; ローカル回避策として位置を point-max でクランプする (jinx 2.8)。
  (advice-add 'jinx--check-pending :filter-args
              (lambda (args)
                (list (min (nth 0 args) (point-max))
                      (min (nth 1 args) (point-max))))))

;;----------------------------------------------------------------------------------
;; Tree-sitter
;;----------------------------------------------------------------------------------
(use-package treesit
  :straight (:type built-in)
  :custom
  (treesit-font-lock-level 4)
  :config
  (setq treesit-language-source-alist
        '((astro "https://github.com/virchau13/tree-sitter-astro")
          (bash "https://github.com/tree-sitter/tree-sitter-bash")
          (css "https://github.com/tree-sitter/tree-sitter-css")
          (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
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
  (add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode)))

;;----------------------------------------------------------------------------------
;; LSP
;;----------------------------------------------------------------------------------
(use-package lsp-mode
  :init
  ;; Must be set before lsp-mode is loaded so the keymap is built correctly.
  (setq lsp-keymap-prefix "C-c l")

  :custom
  (lsp-completion-provider :none) ; with corfu
  ;; gc-cons-threshold は Basics セクションでグローバルに 128MB を設定済みのためここでは設定しない
  (read-process-output-max (* 1024 1024))
  (lsp-idle-delay 0.1)
  (lsp-signature-auto-activate nil)
  (lsp-auto-guess-root t)
  (lsp-lens-enable nil)
  (lsp-modeline-code-actions-enable nil)
  ;; JS/TS
  (lsp-javascript-preferences-import-module-specifier "relative")
  (lsp-typescript-preferences-import-module-specifier "relative")

  :config
  ;; (setq lsp-log-io t)

  (defun lsp/ensure-server (package)
    (lambda (_client callback error-callback _update?)
      (lsp-package-ensure package callback error-callback)))

  ;; Kotlin
  (defun kotlin-lsp-server-start-fun (port)
    (list "kotlin-lsp.sh" "--socket" (number-to-string port)))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-tcp-connection 'kotlin-lsp-server-start-fun)
    :activation-fn (lsp-activate-on "kotlin")
    :major-modes '(kotlin-mode kotlin-ts-mode)
    :priority -1
    :server-id 'kotlin-jb-lsp))

  ;; CloudFormation
  (defvar cfn-lsp/server-path
    (expand-file-name "~/.local/share/cfn-lsp/cfn-lsp-server-standalone.js")
    "Path to CloudFormation Language Server")
  (defun cfn-lsp/cloudformation-buffer-p (&optional _filename _mode)
    "現在のバッファが CloudFormation テンプレートかを判定する。
  バッファ先頭付近に AWSTemplateFormatVersion キーが存在すれば非 nil を返す。"
    (and (derived-mode-p 'yaml-ts-mode 'yaml-mode 'json-ts-mode 'json-mode)
         (save-excursion
           (save-restriction
             (widen)
             (goto-char (point-min))
             ;; 先頭 4KB 以内に YAML/JSON いずれの記法でも一致するよう検索
             (let ((search-limit (min (point-max) (+ (point-min) 4096))))
               (re-search-forward
                "[\"']?AWSTemplateFormatVersion[\"']?[[:space:]]*:"
                search-limit t))))))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection (lambda ()
                                            (list "node" cfn-lsp/server-path "--stdio")))
    :activation-fn #'cfn-lsp/cloudformation-buffer-p
    :priority 1
    :server-id 'cfn-lsp
    :initialization-options
    (lambda ()
      (list :aws
            (list :clientInfo
                  (list :extension (list :name "emacs" :version emacs-version))
                  :telemetryEnabled t
                  :logLevel "info")))))

  (puthash "aws/documents/metadata" #'ignore
           (lsp--client-notification-handlers
            (gethash 'cfn-lsp lsp-clients)))

  ;; Docker Compose
  ;; https://github.com/microsoft/compose-language-service
  (lsp-dependency 'compose-ls
                  '(:npm :package "@microsoft/compose-language-service"
                         :path "docker-compose-langserver"))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     (lambda ()
                       `(,(lsp-package-path 'compose-ls) "--stdio")))
    :activation-fn (lsp-activate-on "docker-compose")
    :priority 1
    :server-id 'compose-ls
    :download-server-fn (lsp/ensure-server 'compose-ls)))

  ;; GitHub Actions
  ;; https://github.com/actions/languageservices/tree/main/languageserver
  (defun actions-ls/buffer-p (&optional _filename _mode)
    (and buffer-file-name
         (not (file-remote-p buffer-file-name))
         (derived-mode-p 'yaml-ts-mode 'yaml-mode)
         (string-match-p "\\.github/workflows/[^/]+\\.ya?ml\\'" buffer-file-name)))

  (defun actions-ls/init-options ()
    (let* ((token (string-trim (shell-command-to-string "gh auth token 2>/dev/null")))
           ;; sessionToken: uses: のアクション入力補完・runs-on ラベル補完・アクション参照バリデーションを有効化
           (git-root (string-trim (shell-command-to-string "git rev-parse --show-toplevel 2>/dev/null")))
           (remote-url (string-trim (shell-command-to-string "git remote get-url origin 2>/dev/null")))
           (owner-repo (or (and (string-match "github\\.com[:/]\\([^/]+\\)/\\([^/\\.]+\\)" remote-url)
                                (list (match-string 1 remote-url) (match-string 2 remote-url)))
                           nil))
           ;; repos: secrets.* / vars.* の実名補完・ローカル再利用ワークフローの解決を追加で有効化
           (repos (when (and owner-repo (not (string-empty-p git-root)))
                    (let* ((owner (car owner-repo))
                           (name (cadr owner-repo))
                           (repo-info (string-trim (shell-command-to-string
                                                    (format "gh repo view %s/%s --json id,owner --template '{{.id}}\t{{.owner.type}}' 2>/dev/null"
                                                            owner name))))
                           (parts (split-string repo-info "\t")))
                      (list (list :id (if (and (= (length parts) 2) (string-match-p "^[0-9]+$" (car parts)))
                                          (string-to-number (car parts)) 0)
                                  :owner owner
                                  :name name
                                  :organizationOwned (equal (cadr parts) "Organization")
                                  :workspaceUri (concat "file://" git-root)))))))
      (append (unless (string-empty-p token) (list :sessionToken token))
              (when repos (list :repos (vconcat repos))))))

  (lsp-dependency 'actions-languageserver
                  '(:npm :package "@actions/languageserver"
                         :path "actions-languageserver"))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     (lambda ()
                       `(,(lsp-package-path 'actions-languageserver) "--stdio")))
    :activation-fn #'actions-ls/buffer-p
    :priority 1
    :server-id 'actions-ls
    :initialization-options #'actions-ls/init-options
    :download-server-fn (lsp/ensure-server 'actions-languageserver)))

  ;; repos の workspaceUri に基づいてローカルワークフローファイルを返すサーバー起点リクエスト
  (puthash "actions/readFile"
           (lambda (_workspace params)
             (let* ((path (gethash "path" params))
                    (file-path (lsp--uri-to-path path)))
               (when (file-readable-p file-path)
                 (with-temp-buffer
                   (insert-file-contents file-path)
                   (buffer-string)))))
           (lsp--client-request-handlers
            (gethash 'actions-ls lsp-clients)))

  ;; Laravel (laravel-ls)
  ;; https://github.com/laravel-ls/laravel-ls
  (defun laravel-ls/buffer-p (&optional _filename _mode)
    "現在のバッファが Laravel プロジェクトの PHP もしくは Blade かを判定する。
上位に artisan を持つディレクトリ木の配下にあれば Laravel プロジェクトとみなす。"
    (and buffer-file-name
         (not (file-remote-p buffer-file-name)) ; TRAMP では stat が高コストなため除外
         (or (derived-mode-p 'php-ts-mode)
             (and (derived-mode-p 'web-mode)
                  (string-match-p "\\.blade\\.php\\'" buffer-file-name)))
         (locate-dominating-file buffer-file-name "artisan")
         t))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("laravel-ls"))
    :activation-fn #'laravel-ls/buffer-p
    :add-on? t
    :server-id 'laravel-ls))

  ;; ignore laravel's storage directory
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]storage\\'")

  ;; lsp-graphql.el は TS/JS も activation-fn の対象として登録するため、
  ;; graphql-mode 以外では graphql-lsp を起動しないよう除外する。
  (defun lsp/disable-graphql-lsp ()
    (setq-local lsp-disabled-clients '(graphql-lsp)))
  (dolist (hook '(typescript-ts-mode-hook tsx-ts-mode-hook js-ts-mode-hook))
    (add-hook hook #'lsp/disable-graphql-lsp))

  (defun lsp/enable-graphql ()
    "graphql-lsp を現在のバッファで手動起動する。gql`` を使うファイルで呼ぶ。"
    (interactive)
    (setq-local lsp-disabled-clients
                (remove 'graphql-lsp lsp-disabled-clients))
    (lsp))

  (add-to-list 'lsp-language-id-configuration '(web-mode . "html"))

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
         (web-mode . lsp)
         (bash-ts-mode . lsp)
         (terraform-mode . lsp)
         (graphql-mode . lsp)
         (sql-mode . lsp)
         (markdown-mode . lsp)
         (json-ts-mode . lsp)
         (toml-ts-mode . lsp)
         (yaml-ts-mode . lsp)
         (dockerfile-ts-mode . lsp)
         (docker-compose-mode . lsp))
  :commands lsp)

(use-package lsp-ui
  :custom
  (lsp-eldoc-render-all t)
  (lsp-ui-sideline-diagnostic-max-lines 3)
  :commands lsp-ui-mode)

(use-package dap-mode
  :after (lsp-mode)
  :custom
  (dap-auto-configure-features '(sessions locals controls tooltip)))

;;----------------------------------------------------------------------------------
;; Languages
;;----------------------------------------------------------------------------------
(use-package csv-mode
  :mode (("\\.csv\\'" . csv-mode)
         ("\\.tsv\\'" . tsv-mode)))

(use-package sql-indent
  :hook (sql-mode . sqlind-minor-mode))

(use-package js-ts-mode
  :straight (:type built-in)
  :mode (("\\.js\\'" . js-ts-mode)
         ("\\.cjs\\'" . js-ts-mode)
         ("\\.mjs\\'" . js-ts-mode))
  :custom
  (js-indent-level 2))

;; (use-package rjsx-mode
;;   :mode (("\\.js\\'" . rjsx-mode))
;;   )

(use-package pnpm-mode
  :commands pnpm-mode)

(use-package typescript-ts-mode
  :straight (:type built-in)
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :custom
  (typescript-ts-mode-indent-offset 2))

(use-package prisma-mode
  :straight (:host github :repo "pimeys/emacs-prisma-mode" :branch "main")
  :mode ("\\.prisma\\'" . prisma-mode))

(use-package astro-ts-mode
  :mode ("\\.astro\\'" . astro-ts-mode))

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
  :custom
  (php-ts-mode-indent-style 'psr2))

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.blade\\.php\\'" . web-mode))
  :custom
  (web-mode-enable-auto-closing t)
  (web-mode-enable-auto-pairing t)
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-style-padding 2)
  (web-mode-script-padding 2)
  (web-mode-block-padding 0)
  (web-mode-enable-css-colorization t)
  (web-mode-engines-alist '(("php" . "\\.phtml\\'")
                            ("blade" . "\\.blade\\.php\\'"))))

(use-package lsp-php
  :straight nil
  :config
  ;; web-mode の :mode を lsp-php.el が上書きするため、ロード後に再 push する。
  (push '("\\.blade\\.php\\'" . web-mode) auto-mode-alist))

(define-derived-mode vue-mode
  web-mode "vue")
(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode))

(use-package go-ts-mode
  :mode ("\\.go\\'" . go-ts-mode)
  :custom (gofmt-command "goimports"))

(use-package go-eldoc
  :custom (go-eldoc-gocode "gopls")
  :hook ((go-ts-mode . go-eldoc-setup)))

(use-package terraform-mode
  :mode (("\\.tf\\'" . terraform-mode)
         ("\\.tfvars\\'" . terraform-mode)))

(use-package kotlin-ts-mode
  ;; :straight (:host gitlab :repo "bricka/emacs-kotlin-ts-mode")
  :mode "\\.kts?\\'")

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :custom
  (markdown-command "cmark-gfm -e table")
  (markdown-command-needs-filename t)
  (markdown-live-preview-delete-export 'delete-on-export)
  (markdown-content-type "application/xhtml+xml")
  (markdown-xhtml-body-preamble "<div class='markdown-body'>")
  (markdown-xhtml-body-epilogue "</div>")
  (markdown-fontify-code-blocks-natively t)
  (markdown-css-paths '("https://cdn.jsdelivr.net/npm/github-markdown-css")))

(use-package plantuml-mode
  :mode (("\\.puml\\'" . plantuml-mode)
         ("\\.plantuml\\'" . plantuml-mode)
         ("\\.pu\\'" . plantuml-mode))
  :custom
  (plantuml-default-exec-mode 'jar))

(use-package mermaid-mode
  :mode (("\\.mmd\\'" . mermaid-mode)
         ("\\.mermaid\\'" . mermaid-mode)))

(use-package toml-ts-mode
  :straight (:type built-in)
  :mode (("\\.toml\\'" . toml-ts-mode)))

(use-package yaml-ts-mode
  :straight (:type built-in)
  :mode (("\\.ya?ml\\'" . yaml-ts-mode))
  :bind (:map yaml-ts-mode-map
              ("C-m" . newline-and-indent)))

(use-package json-ts-mode
  :straight (:type built-in)
  :mode (("\\.jsonc?\\'" . json-ts-mode))
  :custom
  (json-ts-mode-indent-offset 4))

(use-package docker
  :bind ("C-c d" . docker))

(use-package dockerfile-ts-mode
  :straight (:type built-in)
  :mode (("Dockerfile\\'" . dockerfile-ts-mode)))

(use-package docker-compose-mode
  :mode (("docker-compose[^/]*\\.ya?ml\\'" . docker-compose-mode)
         ("compose[^/]*\\.ya?ml\\'" . docker-compose-mode))
  :config
  (add-to-list 'lsp-language-id-configuration
               '(docker-compose-mode . "docker-compose")))

(use-package nginx-mode
  :mode (("nginx\\.conf\\'" . nginx-mode)))

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
    (set-process-query-on-exit-flag
     (start-process-shell-command "displayline" nil (concat cmd " " args)) nil)))

(use-package tex-mode
  :straight (:type built-in)
  :custom
  (tex-default-mode 'latex-mode)
  (tex-start-commands "\\nonstopmode\\input")
  (tex-run-command "ptex2pdf -u -e -ot '-synctex=1 -interaction=nonstopmode'")
  (latex-run-command "ptex2pdf -u -l -ot '-synctex=1 -interaction=nonstopmode'")
  (tex-bibtex-command "latexmk -norc -gg -pdfdvi")
  (tex-print-file-extension ".pdf")
  (tex-dvi-view-command "open -a /Applications/Skim.app")
  (tex-dvi-print-command "open -a /Applications/Preview.app")
  (tex-compile-commands
   '(("ptex2pdf -u -l -ot '-synctex=1 -interaction=nonstopmode' %f" "%f" "%r.pdf")
     ("latexmk %f" "%f" "%r.pdf")
     ("latexmk -norc -gg -pdfdvi %f" "%f" "%r.pdf")
     ("latexmk -norc -gg -pdflua %f" "%f" "%r.pdf")
     ((concat "\\doc-view" " \"" (car (split-string (format "%s" (tex-main-file)) "\\.")) ".pdf\"") "%r.pdf")
     ("open -a /Applications/Skim.app %r.pdf" "%r.pdf")
     ("open -a /Applications/Preview %r.pdf" "%r.pdf")
     ("open -a \"Google Chrome\" %r.pdf" "%r.pdf")))
  :bind (:map latex-mode-map
              ("C-c s" . skim-forward-search))
  :hook (latex-mode . turn-on-reftex)
  :mode (("\\.tex\\'" . latex-mode)))

;;----------------------------------------------------------------------------------
;; Org
;;----------------------------------------------------------------------------------
(use-package org
  :straight (:type built-in)
  :bind
  ("C-c c" . org-capture)
  ("C-c a" . org-agenda)
  :custom
  ;; Basics
  (org-directory "~/org/")
  (org-default-notes-file (concat org-directory "index.org"))
  (org-use-speed-commands t)
  ;; Task Managements
  (org-todo-keywords '((sequence
                        "TODO(!)" "NOT STARTED(n!)" "IN PROGRESS(p!)" "WAITING(w!)" "FUTURE(f!)"
                        "|" "DONE(d!)" "DECLINED(x!)")))
  (org-todo-keyword-faces '(("TODO" . (:foreground "brightyellow" :weight bold)) ("NOT STARTED" . (:foreground "deeppink" :weight bold))
                            ("IN PROGRESS" . (:foreground "paleturquoise" :weight bold)) ("WAITING" . (:foreground "lightcyan" :weight bold))
                            ("FUTURE" . (:foreground "palegoldenrod" :background "darkgray" :weight bold))
                            ("DONE" . (:foreground "palegreen" :weight bold)) ("DECLINED" . (:foreground "palegreen" :background "darkgray" :weight bold))))
  (org-priority-faces '((?A . (:foreground "orangered" :weight bold))
                        (?B . (:foreground "yellowgreen"))
                        (?C . (:foreground "brightblue"))))
  ;; Export
  (org-export-with-toc nil)
  (org-export-with-date nil)
  (org-export-with-author nil)
  ;; Babel
  (org-confirm-babel-evaluate nil)
  :config
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((emacs-lisp . t)
                                 (shell . t)
                                 (sql . t)
                                 (http . t))))

(use-package org-agenda
  :straight (:type built-in)
  :after org
  :custom
  (org-agenda-files (directory-files-recursively org-directory "\\.org\\'"))
  (org-agenda-window-setup 'current-window)
  (calendar-holidays nil)
  (org-refile-targets '((org-agenda-files :maxlevel . 2)))
  (org-agenda-sorting-strategy '(deadline-up scheduled-up todo-state-up priority-down))
  (org-agenda-skip-timestamp-if-done t)
  (org-agenda-skip-deadline-if-done t)
  (org-agenda-skip-scheduled-if-done t)
  (org-agenda-skip-scheduled-if-deadline-is-shown t)
  (org-agenda-skip-timestamp-if-deadline-is-shown t))

(use-package org-super-agenda
  :after org-agenda
  :custom
  (org-super-agenda-groups
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
  :config
  (org-super-agenda-mode 1))

(use-package org-capture
  :straight (:type built-in)
  :after org
  :custom
  (org-capture-templates
   '(("t" "Task" entry (file+headline "" "Tasks")
      "* TODO %?\n  %u\n  %a"
      :empty-lines 1)
     ("s" "Sticky note" entry (file+datetree org-default-notes-file)
      "* %U\n%?\n%i\n"
      :empty-lines 1))))

(use-package ox-md
  :straight (:type built-in)
  :after org)

(use-package ox-latex
  :straight (:type built-in)
  :after org
  :custom
  (org-latex-default-class "jlreq")
  (org-latex-compiler "lualatex")
  (org-latex-pdf-process '("lualatex %b"))
  (org-latex-with-hyperref nil)
  :config
  (add-to-list 'org-latex-classes
               '("jlreq"
                 "\\documentclass{jlreq}
                  [NO-DEFAULT-PACKAGES]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-packages-alist
               '("normalem" "ulem" t)))

(use-package ob-http
  :after org)

;;----------------------------------------------------------------------------------
;; Shell
;;----------------------------------------------------------------------------------
(use-package eat
  :bind ("C-c C-t" . eat-project-other-window)
  :config
  (eat-eshell-mode))


(use-package restclient
  :mode ("\\.http\\'" . restclient-mode)
  :custom
  (restclient-enable-eval t))
(use-package restclient-jq
  :after restclient)

(use-package graphql-mode
  :mode (("\\.graphql\\'" . graphql-mode)
         ("\\.gql\\'" . graphql-mode)))
(use-package request
  :defer t)

(provide 'init)
;;; init.el ends here
