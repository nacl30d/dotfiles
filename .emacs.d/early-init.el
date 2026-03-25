;;; early-init.el --- Early init -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:
(setenv "LSP_USE_PLISTS" "true")
(setq package-enable-at-startup nil)

(setq inhibit-startup-message t)        ;hidden startup msg
(menu-bar-mode -1)                      ;hidden menu bar

(provide 'early-init)
;;; early-init.el ends here
