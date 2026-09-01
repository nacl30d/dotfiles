;;; early-init.el --- Early init -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:
(setenv "LSP_USE_PLISTS" "true")
(setq package-enable-at-startup nil)

;; straight のデフォルト find-at-startup は起動毎に全リポジトリへ find をかけ
;; 数百 ms を要する。ソースを Emacs 外で編集した場合は M-x straight-check-all
;; 等で明示的に再ビルドする運用とし、起動時の走査を避ける。
;; bootstrap ロード前に評価される必要があるため early-init に置く。
(setq straight-check-for-modifications '(check-on-save find-when-checking))

(setq inhibit-startup-message t)        ;hidden startup msg
(menu-bar-mode -1)                      ;hidden menu bar

(provide 'early-init)
;;; early-init.el ends here
