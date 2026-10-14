;;; auth-source-forge-cli.el --- Auth-source backends backed by forge CLIs -*- lexical-binding: t; -*-

;;; Commentary:

;; Ghub (and therefore Forge) looks tokens up through auth-source, so using the
;; tokens gh and glab already hold would otherwise mean copying them into
;; ~/.authinfo.gpg, where they go stale every time the CLI rotates them.  These
;; backends delegate the lookup to the CLI instead.
;;
;; Enable them by putting `gh-cli' and/or `glab-cli' into `auth-sources'.  Every
;; backend is asked about every host and declines the ones its CLI does not know,
;; so self-hosted instances need no host-to-CLI mapping.

;;; Code:

(require 'auth-source)
(require 'cl-lib)
(require 'subr-x)

(defgroup auth-source-forge-cli nil
  "Auth-source backends backed by the GitHub and GitLab CLIs."
  :group 'auth-source)

(defcustom auth-source-forge-cli-gh-program "gh"
  "Name of or path to the GitHub CLI executable."
  :type 'string)

(defcustom auth-source-forge-cli-glab-program "glab"
  "Name of or path to the GitLab CLI executable."
  :type 'string)

(defun auth-source-forge-cli--hostname (host)
  "Return the CLI hostname matching auth-source HOST, or nil."
  (and (stringp host)
       ;; Ghub asks for "api.github.com", "gitlab.com/api/v4" and for GHE
       ;; "ghe.example.com/api/v3", none of which a CLI accepts as a hostname.
       (let ((host (car (split-string host "/" t))))
         (if (string-prefix-p "api." host)
             (substring host 4)
           host))))

(defun auth-source-forge-cli--login (user)
  "Return the CLI account login matching auth-source USER, or nil.
Nil means the CLI picks the account active for the host."
  (and (stringp user)
       ;; Ghub identifies itself by searching for "LOGIN^PACKAGE".
       (car (split-string user "\\^"))))

(defun auth-source-forge-cli--output (program &rest args)
  "Return the trimmed standard output of PROGRAM ARGS, or nil when it fails."
  (and (executable-find program)
       (with-temp-buffer
         (and (zerop (apply #'call-process program nil '(t nil) nil args))
              (let ((output (string-trim (buffer-string))))
                (and (not (string-empty-p output)) output))))))

(defun auth-source-forge-cli--gh-token (hostname login)
  "Return the token gh holds for LOGIN on HOSTNAME, or nil."
  (apply #'auth-source-forge-cli--output
         auth-source-forge-cli-gh-program
         "auth" "token" "--hostname" hostname
         (and login (list "--user" login))))

(defun auth-source-forge-cli--glab-token (hostname _login)
  "Return the token glab holds for HOSTNAME, or nil.
The login is ignored because glab keeps a single token per host; the
account-aware `glab auth status --show-token' prints a human-readable
report that would have to be screen-scraped."
  (auth-source-forge-cli--output
   auth-source-forge-cli-glab-program
   "config" "get" "token" "--host" hostname))

(defun auth-source-forge-cli--search (token-function backend host user)
  "Return auth-source results for HOST and USER from BACKEND.
TOKEN-FUNCTION is called with the hostname and the login."
  (and-let* ((hostname (auth-source-forge-cli--hostname host))
             (token (funcall token-function hostname
                             (auth-source-forge-cli--login user))))
    (list (list :backend backend :host host :user user :secret token))))

(cl-defun auth-source-forge-cli-gh-search (&key backend host user &allow-other-keys)
  "Search function of the `gh-cli' BACKEND, for HOST and USER."
  (auth-source-forge-cli--search
   #'auth-source-forge-cli--gh-token backend host user))

(cl-defun auth-source-forge-cli-glab-search (&key backend host user &allow-other-keys)
  "Search function of the `glab-cli' BACKEND, for HOST and USER."
  (auth-source-forge-cli--search
   #'auth-source-forge-cli--glab-token backend host user))

(defun auth-source-forge-cli-backend-parse (entry)
  "Return a backend when ENTRY of `auth-sources' names a forge CLI."
  (pcase entry
    ('gh-cli
     (make-instance 'auth-source-backend
                    :source "gh-cli"
                    :type 'gh-cli
                    :search-function #'auth-source-forge-cli-gh-search))
    ('glab-cli
     (make-instance 'auth-source-backend
                    :source "glab-cli"
                    :type 'glab-cli
                    :search-function #'auth-source-forge-cli-glab-search))))

(add-hook 'auth-source-backend-parser-functions
          #'auth-source-forge-cli-backend-parse)

(provide 'auth-source-forge-cli)
;;; auth-source-forge-cli.el ends here
