;;; init.el --- my init el -*- lexical-binding: t; -*-
;;; commentary:

;; prerequirements
;;   - git for package, magit
;;   - lints for flycheck

;;; Code:

;; (setq debug-on-error t)

;; MacOSX27.0.sdk の libSystem.B.tbd に arm64e.x1-macos という未知のアーキテクチャが
;; 含まれており、cc によるネイティブコンパイル時にリンクエラーが発生する。
;; MacOSX26.5.sdk を明示することで回避する。
(setenv "SDKROOT" "/Library/Developer/CommandLineTools/SDKs/MacOSX26.5.sdk")

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

(setopt straight-use-package-by-default t)

;;----------------------------------------------------------------------------------
;; Encoding and Language
;;----------------------------------------------------------------------------------
(prefer-coding-system 'utf-8)

;;----------------------------------------------------------------------------------
;; Basics
;;----------------------------------------------------------------------------------
(setopt tab-width 4 indent-tabs-mode nil)
(global-auto-revert-mode 1)
(repeat-mode 1)
(keymap-global-set "C-x ," #'previous-buffer)
(keymap-global-set "C-x ." #'next-buffer)
(keymap-set buffer-navigation-repeat-map "," #'previous-buffer)
(keymap-set buffer-navigation-repeat-map "." #'next-buffer)
(setopt use-short-answers t)
(setopt backup-directory-alist          ;backup file dir
        (cons (cons ".*" (locate-user-emacs-file ".backup/"))
              backup-directory-alist))
(setopt auto-save-file-name-transforms  ;auto-save file dir
        `((".*" ,(locate-user-emacs-file ".backup/") t)))
(setopt auto-save-list-file-prefix (locate-user-emacs-file ".backup/auto-save-list/.saves-"))
(setopt backup-by-copying t)
(setopt require-final-newline t)

(use-package recentf
  :straight (:type built-in)
  :custom
  (recentf-max-saved-items 32)
  ;; daemon は終了しないため、kill-emacs-hook による保存だけでは異常終了時に履歴が失われる。
  (recentf-autosave-interval 300)
  :config
  (recentf-mode))

(use-package savehist
  :straight (:type built-in)
  :init
  (savehist-mode))

(use-package dired
  :straight (:type built-in)
  :custom
  (dired-kill-when-opening-new-dired-buffer t))

(use-package so-long
  :straight (:type built-in)
  :init
  (global-so-long-mode))

(keymap-global-set "s-<return>" #'toggle-frame-fullscreen)

;;----------------------------------------------------------------------------------
;; Mode Line
;;----------------------------------------------------------------------------------
(use-package time
  :straight (:type built-in)
  :custom
  (display-time-default-load-average nil)
  (display-time-24hr-format t)
  (display-time-day-and-date t)
  :config
  (display-time-mode t))

(use-package display-line-numbers
  :straight (:type built-in)
  :hook ((prog-mode text-mode conf-mode) . display-line-numbers-mode)
  :config
  (setq display-line-numbers-width-start t))

(use-package simple
  :straight (:type built-in)
  :config
  (column-number-mode t))

(use-package emacs
  :straight (:type built-in)
  :custom
  (mode-line-collapse-minor-modes '(eldoc-mode
                                    git-gutter-mode
                                    jinx-mode
                                    mise-mode
                                    subword-mode
                                    which-key-mode)))

;;----------------------------------------------------------------------------------
;; Version Control System
;;----------------------------------------------------------------------------------
(setopt vc-follow-symlinks t)

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package git-modes
  :mode (("\\.gitconfig" . gitconfig-mode)
         ("\\.gitignore" . gitignore-mode)))

(use-package auth-source-forge-cli
  :straight nil
  :demand t
  :custom
  (auth-sources '(gh-cli glab-cli "~/.authinfo.gpg")))

(use-package forge
  :after magit)

(use-package git-link
  :bind ("C-c i" . git-link)
  :custom
  (git-link-open-in-browser t))

(use-package git-gutter
  :hook (find-file-hook . git-gutter-mode))

(use-package difftastic-bindings
  :straight difftastic
  :config (difftastic-bindings-mode))

;;----------------------------------------------------------------------------------
;; Views
;;----------------------------------------------------------------------------------
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
  :bind
  ("M-0" . tab-recent)
  :custom
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  (tab-bar-auto-width nil)
  (tab-bar-separator " ")
  (tab-bar-format '(tab-bar-format-tabs-groups)))

(use-package tab-line
  :init
  (global-tab-line-mode 1)
  :custom
  (tab-line-new-button-show nil)
  (tab-line-close-button-show nil))

(use-package winum
  :init
  ;; 既定の winum-keymap は C-x w を winum-base-map で覆い、組み込みの window-prefix-map を隠す。
  (setq winum-keymap (make-sparse-keymap))
  (winum-mode)
  :config
  ;; window-list の順で数えると、winum が番号を振らない treemacs なども数えてしまい表示とずれる。
  (dolist (n (number-sequence 1 9))
    (keymap-global-set (format "M-%d" n) (intern (format "winum-select-window-%d" n)))))

(use-package dracula-theme               ;theme
  :init
  (load-theme 'dracula t)
  ;; TTY フレームでは :family は無視され、端末側のフォント設定が使われる。
  (set-face-attribute 'default nil :family "FirgeNerd Console" :height 190)
  (set-face-attribute 'fixed-pitch nil :family "FirgeNerd Console")
  (setq ns-use-thin-smoothing t)
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
  (set-face-attribute 'font-lock-doc-face nil :slant 'italic))

(use-package nerd-icons
  :custom
  (nerd-icons-font-family "FirgeNerd Console"))

(use-package hiwin                      ;change background color if active window or not
  :init
  (hiwin-activate)
  :config
  (set-face-background 'hiwin-face "gray50"))

;; 全角スペースはフォント (Firge) が可視化するため whitespace-mode は使わない。
;; 行末スペースは Markdown の改行に使うため、保存時に削除せず表示のみとする。
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook (lambda () (setq-local show-trailing-whitespace t))))

(use-package treemacs
  :bind
  (:map global-map
        ("C-c e 1"   . treemacs-delete-other-windows)
        ("C-c e e"   . treemacs)
        ("C-c e d"   . treemacs-select-directory)
        ("C-c e B"   . treemacs-bookmark)
        ("C-c e C-t" . treemacs-find-file)
        ("C-c e M-t" . treemacs-find-tag))

  :config
  (treemacs-follow-mode t)
  (treemacs-project-follow-mode t)
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

(use-package popper
  :bind (("C-c z" . popper-toggle)
         ("C-c Z" . popper-cycle))
  :custom
  (popper-reference-buffers
   '("\\*Messages\\*"
     "\\*Warnings\\*"
     "Output\\*$"
     "\\*Async Shell Command\\*"
     help-mode
     compilation-mode
     magit-process-mode))
  :init
  (popper-mode)
  (popper-echo-mode))

;;----------------------------------------------------------------------------------
;; Edit
;;----------------------------------------------------------------------------------
(keymap-set key-translation-map "C-h" "DEL")
(keymap-global-set "M-/" #'comment-line)

(use-package subword
  :straight (:type built-in)
  :init
  (global-subword-mode))

(use-package editorconfig
  :straight (:type built-in)
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

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
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
   ("C-x B" . consult-buffer)
   ("C-x b" . consult-project-buffer)
   ("C-c g" . consult-goto-line)
   ("C-c j" . consult-git-grep)
   ("M-g i" . consult-imenu)
   ("C-c A" . consult-org-agenda)
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
;; ELPA 版が依存として straight で導入済みのため、:straight (:type built-in) にはしない。
(use-package project
  :demand t
  :custom
  (project-vc-extra-root-markers '(".project"))
  :config
  (keymap-set project-prefix-map "v" #'magit-project-status)
  (keymap-set project-prefix-map "e" #'ghostel-project)
  (keymap-set project-prefix-map "a" #'claude-code-ide)
  ;; claude-code-ide-menu は transient のため、suffix 実行時には project-switch-project の
  ;; 動的束縛が切れており、切り替え先ではなく元のバッファのプロジェクトで起動してしまう。
  (setopt project-switch-commands
          '((project-find-file "Find file")
            (project-find-regexp "Find regexp")
            (project-find-dir "Find directory")
            (magit-project-status "Magit")
            (ghostel-project "Ghostel")
            (claude-code-ide "Claude Code")
            (project-any-command "Other")))
  (defun my/project-switch-project-in-tab (switch dir)
    (if-let* ((pr (project-current nil dir)))
        (let* ((name (project-name pr))
               (exists (seq-find (lambda (tab) (equal (alist-get 'name tab) name))
                                 (tab-bar-tabs))))
          (tab-bar-switch-to-tab name)
          (unless exists
            (funcall switch dir)))
      (funcall switch dir)))
  (advice-add 'project-switch-project :around
              #'my/project-switch-project-in-tab)
  (defun my/tab-bar-tab-name-project ()
    (with-current-buffer (window-buffer (minibuffer-selected-window))
      (if-let* ((pr (project-current)))
          (project-name pr)
        (tab-bar-tab-name-current))))
  (setq tab-bar-tab-name-function #'my/tab-bar-tab-name-project))

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
  :hook (emacs-startup . global-mise-mode))

;;----------------------------------------------------------------------------------
;; Syntax Checking
;;----------------------------------------------------------------------------------
(use-package flycheck
  :hook (emacs-startup . global-flycheck-mode)
  :custom
  (flycheck-display-errors-delay 0.1))

(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages))
  :custom
  (jinx-languages "en_US")
  (jinx-camel-modes t)
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
  (treesit-auto-install-grammar 'always)
  ;; t は mhtml-ts-mode など使わないモードまで有効にするため、列挙する。
  (treesit-enabled-modes '(bash-ts-mode css-ts-mode js-ts-mode typescript-ts-mode tsx-ts-mode
                           python-ts-mode json-ts-mode toml-ts-mode yaml-ts-mode
                           go-ts-mode go-mod-ts-mode php-ts-mode dockerfile-ts-mode))
  :config
  ;; 組み込み ts-mode や astro-ts-mode などのパッケージが登録する :commit 固定のエントリは
  ;; 各モードのクエリに合わせてあるため、setq で上書きせず、どこにも登録されない言語だけを追加する。
  (dolist (source '((elisp "https://github.com/Wilfred/tree-sitter-elisp")
                    (graphql "https://github.com/bkegley/tree-sitter-graphql")
                    (kotlin "https://github.com/fwcd/tree-sitter-kotlin")
                    (make "https://github.com/alemuller/tree-sitter-make")))
    (add-to-list 'treesit-language-source-alist source)))

;;----------------------------------------------------------------------------------
;; LSP
;;----------------------------------------------------------------------------------
(use-package lsp-mode
  :init
  ;; Must be set before lsp-mode is loaded so the keymap is built correctly.
  (setq lsp-keymap-prefix "C-c l")

  ;; lsp-graphql.el は TS/JS も activation-fn の対象として登録するため、
  ;; graphql-mode 以外では graphql-lsp を起動しないよう除外する。
  ;; :config に置くと、lsp-mode を読み込んだ最初のバッファではモードフックの実行中に追加されて効かない。
  (defun lsp/disable-graphql-lsp ()
    (setq-local lsp-disabled-clients '(graphql-lsp)))
  (dolist (hook '(typescript-ts-mode-hook tsx-ts-mode-hook js-ts-mode-hook))
    (add-hook hook #'lsp/disable-graphql-lsp))

  :custom
  (lsp-completion-provider :none) ; with corfu
  ;; gc-cons-threshold は early-init.el でグローバルに 128MB を設定済みのためここでは設定しない
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
  ;; Auto-install the server from GitHub releases via lsp-mode's :download.
  (defun cfn-lsp/download-url ()
    "Resolve the latest release zip URL for the current platform."
    (let ((os   (pcase system-type ('darwin "darwin") ('windows-nt "win32") (_ "linux")))
          (arch (symbol-name (lsp-resolve-value lsp--system-arch))))
      (lsp--find-latest-gh-release-url
       "https://api.github.com/repos/aws-cloudformation/cloudformation-languageserver/releases/latest"
       (format "%s-%s-node22\\.zip$" os arch))))
  (lsp-dependency 'cfn-lsp
                  `(:download :url cfn-lsp/download-url
                              :decompress :zip
                              :store-path ,(f-join lsp-server-install-dir "cfn-lsp" "cfn-lsp")
                              :binary-path ,(f-join lsp-server-install-dir "cfn-lsp"
                                                    "cfn-lsp-server-standalone.js")))
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
    :new-connection (lsp-stdio-connection
                     (lambda () (list "node" (lsp-package-path 'cfn-lsp) "--stdio"))
                     (lambda () (f-exists? (lsp-package-path 'cfn-lsp))))
    :activation-fn #'cfn-lsp/cloudformation-buffer-p
    :priority 1
    :server-id 'cfn-lsp
    :download-server-fn (lsp/ensure-server 'cfn-lsp)
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

  ;; OpenAPI
  (require 'openapi-project)
  (lsp-dependency 'vacuum
                  '(:npm :package "@quobix/vacuum"
                         :path "vacuum"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     (lambda ()
                       `(,(lsp-package-path 'vacuum) "language-server" "--skip-check")))
    :activation-fn #'openapi/openapi-buffer-p
    :add-on? t
    :server-id 'oapi-ls
    :download-server-fn (lsp/ensure-server 'vacuum)))

  ;; PHPantom (phpantom_lsp)
  ;; https://phpantom-dev.github.io/phpantom_lsp/
  (lsp-dependency 'phpantom-lsp
                  '(:system "phpantom_lsp")
                  `(:download :url ,(format "https://github.com/PHPantom-dev/phpantom_lsp/releases/latest/download/phpantom_lsp-%s-%s.tar.gz"
                                            (if (string-prefix-p "aarch64-" system-configuration) "aarch64" "x86_64")
                                            (if (eq system-type 'darwin) "apple-darwin" "unknown-linux-gnu"))
                              :decompress :targz
                              :store-path ,(f-join lsp-server-install-dir "phpantom-lsp" "phpantom_lsp")))

  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     (lambda () (lsp-package-path 'phpantom-lsp))
                     (lambda () (lsp-package-path 'phpantom-lsp)))
    :activation-fn (lsp-activate-on "php" "php-ts")
    :priority 0
    :server-id 'phpantom-lsp
    :download-server-fn (lsp/ensure-server 'phpantom-lsp)))

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

  (defun lsp/enable-graphql ()
    "graphql-lsp を現在のバッファで手動起動する。gql`` を使うファイルで呼ぶ。"
    (interactive)
    (setq-local lsp-disabled-clients
                (remove 'graphql-lsp lsp-disabled-clients))
    (lsp))

  (add-to-list 'lsp-language-id-configuration '(web-mode . "html"))
  (add-to-list 'lsp-language-id-configuration '(docker-compose-mode . "docker-compose"))

  :hook (
         (astro-ts-mode . lsp-deferred)
         (go-ts-mode . lsp-deferred)
         (js-ts-mode . lsp-deferred)
         (kotlin-ts-mode . lsp-deferred)
         (typescript-ts-mode . lsp-deferred)
         (tsx-ts-mode . lsp-deferred)
         (php-ts-mode . lsp-deferred)
         (python-ts-mode . lsp-deferred)
         (vue-mode . lsp-deferred)
         (web-mode . lsp-deferred)
         (bash-ts-mode . lsp-deferred)
         (terraform-mode . lsp-deferred)
         (graphql-mode . lsp-deferred)
         (sql-mode . lsp-deferred)
         (markdown-mode . lsp-deferred)
         (json-ts-mode . lsp-deferred)
         (toml-ts-mode . lsp-deferred)
         (yaml-ts-mode . lsp-deferred)
         (dockerfile-ts-mode . lsp-deferred)
         (docker-compose-mode . lsp-deferred))
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
  :mode (("\\.cjs\\'" . js-ts-mode)
         ("\\.mjs\\'" . js-ts-mode))
  :custom
  (js-indent-level 2))

(use-package pnpm-mode
  :commands pnpm-mode)

(use-package typescript-ts-mode
  :straight (:type built-in)
  :defer t
  :custom
  (typescript-ts-mode-indent-offset 2))

(use-package prisma-mode
  :straight (:host github :repo "pimeys/emacs-prisma-mode" :branch "main")
  :mode ("\\.prisma\\'" . prisma-mode))

(use-package astro-ts-mode
  :mode ("\\.astro\\'" . astro-ts-mode)
  ;; astro-ts-mode は treesit-ready-p のみで treesit-ensure-installed を呼ばないため、
  ;; treesit-auto-install-grammar だけでは grammar が自動取得されない。
  :config
  (mapc #'treesit-ensure-installed '(astro css typescript)))

(use-package php-ts-mode
  :straight (:type built-in)
  :defer t
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
  :after lsp-mode
  :config
  ;; web-mode の :mode を lsp-php.el が上書きするため、ロード後に再 push する。
  (push '("\\.blade\\.php\\'" . web-mode) auto-mode-alist))

(define-derived-mode vue-mode
  web-mode "vue")
(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode))

(use-package terraform-mode
  :mode (("\\.tf\\'" . terraform-mode)
         ("\\.tfvars\\'" . terraform-mode)))

(use-package kotlin-ts-mode
  ;; :straight (:host gitlab :repo "bricka/emacs-kotlin-ts-mode")
  :mode "\\.kts?\\'"
  ;; astro-ts-mode と同様 treesit-ensure-installed を呼ばないため明示的に取得する
  :init
  (treesit-ensure-installed 'kotlin))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . gfm-mode))
  :custom
  (markdown-command "cmark-gfm -e table -e strikethrough -e autolink -e tasklist -e footnotes --table-prefer-style-attributes --validate-utf8 --unsafe -e tagfilter")
  (markdown-command-needs-filename t)
  (markdown-open-command 'browse-url)
  (markdown-live-preview-delete-export 'delete-on-export)
  (markdown-indent-on-enter 'indent-and-new-item)
  (markdown-header-scaling t)
  (markdown-fontify-code-blocks-natively t)
  (markdown-css-paths (list (expand-file-name "etc/markdown-academic.css" user-emacs-directory)))
  (markdown-xhtml-header-content
   (concat
    "<script src=\"https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js\"></script>\n"
    "<script>document.addEventListener('DOMContentLoaded', () => mermaid.run({ querySelector: 'code.language-mermaid' }))</script>\n"
    )))

(use-package markdown-plantuml
  :straight nil
  :after markdown-mode)

(use-package plantuml-mode
  :mode (("\\.puml\\'" . plantuml-mode)
         ("\\.plantuml\\'" . plantuml-mode)
         ("\\.pu\\'" . plantuml-mode))
  :custom
  (plantuml-default-exec-mode 'jar)
  (plantuml-jar-path (locate-user-emacs-file "plantuml.jar")))

(use-package mermaid-mode
  :mode (("\\.mmd\\'" . mermaid-mode)
         ("\\.mermaid\\'" . mermaid-mode)))

(use-package yaml-ts-mode
  :straight (:type built-in)
  :bind (:map yaml-ts-mode-map
              ("C-m" . newline-and-indent)))

(use-package openapi-ref
  :straight nil
  :after yaml-ts-mode)

(use-package json-ts-mode
  :straight (:type built-in)
  :mode (("\\.jsonc\\'" . json-ts-mode))
  :custom
  (json-ts-mode-indent-offset 4))

(use-package docker
  :bind ("C-c d" . docker))

(use-package docker-compose-mode
  :mode (("docker-compose[^/]*\\.ya?ml\\'" . docker-compose-mode)
         ("compose[^/]*\\.ya?ml\\'" . docker-compose-mode)))

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
  (org-default-notes-file (concat org-directory "projects/inbox.org"))
  (org-use-speed-commands t)
  ;; Task Managements
  (org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                       (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))
  (org-todo-keyword-faces '(("TODO" . (:foreground "brightyellow" :weight bold))
                            ("NEXT" . (:foreground "paleturquoise" :weight bold))
                            ("WAITING" . (:foreground "lightcyan" :weight bold))
                            ("HOLD" . (:foreground "palegoldenrod" :background "darkgray" :weight bold))
                            ("DONE" . (:foreground "palegreen" :weight bold))
                            ("CANCELLED" . (:foreground "palegreen" :background "darkgray" :weight bold))))
  (org-log-done 'time)
  (org-log-into-drawer t)
  ;; 既定の .org_archive は auto-mode-alist に対応付けがなく、開いても org-mode にならない。
  ;; 相対パスは元ファイルのディレクトリが基準になり、projects/ にサブディレクトリを作るとずれる。
  (org-archive-location (concat (expand-file-name org-directory) "archive/%s::"))
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
  ;; ファイルを列挙して渡すと起動時の一覧に固定され、後から追加したファイルが対象外になる。
  ;; ディレクトリを渡せば org が参照のたびに中のファイルを列挙する。
  ;; ただしサブディレクトリの一覧は読み込み時に固定され、追加した場合は再起動が必要になる。
  (org-agenda-files
   (let ((dir (expand-file-name "projects" org-directory)))
     (cons dir (seq-filter #'file-directory-p (directory-files-recursively dir "" t)))))
  (org-agenda-window-setup 'current-window)
  (calendar-holidays nil)
  (org-refile-targets '((org-agenda-files :maxlevel . 2)))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (org-refile-allow-creating-parent-nodes 'confirm)
  (org-agenda-sorting-strategy '(deadline-up scheduled-up todo-state-up priority-down))
  (org-agenda-skip-timestamp-if-done t)
  (org-agenda-skip-deadline-if-done t)
  (org-agenda-skip-scheduled-if-done t)
  (org-agenda-skip-scheduled-if-deadline-is-shown t)
  (org-agenda-skip-timestamp-if-deadline-is-shown t)
  (org-agenda-custom-commands
   '(("d" "Daily"
      ((agenda "" ((org-agenda-span 'day)))
       (tags "LEVEL=1" ((org-agenda-overriding-header "Inbox")
                        (org-agenda-files (list org-default-notes-file))))
       (todo "NEXT" ((org-agenda-overriding-header "Next")))
       (todo "WAITING|HOLD" ((org-agenda-overriding-header "Waiting / Hold")))
       (todo "TODO|NEXT" ((org-agenda-overriding-header "Stuck Projects")
                          (org-agenda-skip-function #'my/org-skip-unless-stuck-project)))
       (tags-todo "SCHEDULED=\"\"/TODO" ((org-agenda-overriding-header "Unplanned Tasks")
                                         (org-agenda-skip-function #'my/org-skip-unless-single-task)))))))
  :config
  ;; 組み込みの org-stuck-projects は子を持たない単発タスクも停滞扱いにする。
  (defun my/org-skip-unless-stuck-project ()
    (let ((states (delq nil (cdr (org-map-entries #'org-get-todo-state nil 'tree)))))
      (when (or (null states) (member "NEXT" states))
        (save-excursion (or (outline-next-heading) (point-max))))))
  ;; プロジェクトの子の TODO は兄弟の NEXT 待ちとして正当なので、祖先に TODO を持つ見出しも除く。
  (defun my/org-skip-unless-single-task ()
    (when (or (cdr (delq nil (org-map-entries #'org-get-todo-state nil 'tree)))
              (save-excursion
                (cl-loop while (org-up-heading-safe) thereis (org-get-todo-state))))
      (save-excursion (or (outline-next-heading) (point-max))))))

(use-package org-capture
  :straight (:type built-in)
  :after org
  :custom
  (org-capture-templates
   '(("t" "Task" entry (file "")
      "* TODO %?\n%U\n%a"
      :empty-lines 1)
     ("m" "Meeting" entry (file "")
      "* %? %t"
      :clock-in t :clock-resume t :empty-lines 1)
     ("n" "Note" entry (file "")
      "* %?\n%U"
      :empty-lines 1))))

(use-package org-clock
  :straight (:type built-in)
  :after org
  :custom
  (org-clock-persist t)
  (org-clock-persist-query-resume nil)
  (org-clock-in-resume t)
  (org-clock-into-drawer t)
  (org-clock-out-remove-zero-time-clocks t)
  (org-clock-out-when-done t)
  :config
  (org-clock-persistence-insinuate))

(use-package org-timesheet
  :straight nil
  :commands org-timesheet-weekly-report
  :bind (("C-c I" . org-timesheet-punch-in)
         ("C-c O" . org-timesheet-punch-out)))

(use-package ox-md
  :straight (:type built-in)
  :after org)

(use-package ox-gfm
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
(use-package ghostel
  :demand t
  :bind (("C-c t" . ghostel-project)
         :map ghostel-semi-char-mode-map
         ("C-s" . consult-line))
  :config
  ;; `add-to-list' では defcustom の :set が走らず、semi-char のキーマップが再構築されない。
  (setopt ghostel-keymap-exceptions
          (append ghostel-keymap-exceptions
                  (mapcar (lambda (n) (format "M-%d" n)) (number-sequence 0 9)))))
(use-package ghostel-eshell
  :straight nil
  :hook (eshell-load . ghostel-eshell-visual-command-mode))

(use-package ghostel-comint
  :straight nil
  :hook (after-init . ghostel-comint-global-mode))

(use-package consult-ghostel
  :straight (:type git :host github :repo "dakra/ghostel"
             :files ("extensions/consult-ghostel/*.el"))
  :after (ghostel consult)
  :demand t
  :bind (("C-c T" . consult-ghostel-project)
         :map ghostel-semi-char-mode-map
         ("C-c h" . consult-ghostel-history)))

;;----------------------------------------------------------------------------------
;; Coding Agents
;;----------------------------------------------------------------------------------
(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el")
  :bind ("C-c C-s" . claude-code-ide-menu)
  :custom
  (claude-code-ide-terminal-backend 'ghostel)
  :config
  (claude-code-ide-emacs-tools-setup))


;;----------------------------------------------------------------------------------
;; API Clients
;;----------------------------------------------------------------------------------
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

(setq custom-file (locate-user-emacs-file "local.el"))
(load custom-file 'noerror)

(provide 'init)
;;; init.el ends here
