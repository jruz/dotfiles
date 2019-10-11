;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; theme
(load-theme 'doom-molokai)

;; background color
(add-to-list 'default-frame-alist '(background-color . "#1d1f21"))

;; font size
(set-face-attribute 'default t :font "Inconsolata")
(set-face-attribute 'default nil :height 140)

;; tabs
(setq-default tab-width 4)

;; word wrap
(global-visual-line-mode t)

;; disable-mouse
(global-disable-mouse-mode)
(mapc #'disable-mouse-in-keymap
  (list evil-motion-state-map
        evil-normal-state-map
        evil-visual-state-map
        evil-insert-state-map))

; disable paste yank
(setq evil-kill-on-visual-paste nil)

;; ;; prettier
;; (add-hook 'js2-mode-hook 'prettier-js-mode)
;; (add-hook 'web-mode-hook 'prettier-js-mode)

;; eslint-fix
(add-hook 'js2-mode-hook 'eslintd-fix-mode)

;; ;; add-node-modules-path
;; (eval-after-load 'js-mode
;;   '(add-hook 'js2-mode-hook #'add-node-modules-path))
