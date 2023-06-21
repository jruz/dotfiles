;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; theme
(load-theme 'doom-molokai t)

;; background color
(add-to-list 'default-frame-alist '(background-color . "#1d1f21"))

;; font size
(set-face-attribute 'default t :font "Inconsolata")
;; External monitor
(set-face-attribute 'default nil :height 240)
;; Retina
;; (set-face-attribute 'default nil :height 180)

(setq doom-unicode-font (font-spec :family "Apple Color Emoji"))

;; tabs
(setq-default tab-width 2)

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

;; prettier
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'typescript-mode-hook 'prettier-js-mode)
(add-hook 'json-mode-hook 'prettier-js-mode)
(add-hook 'css-mode-hook 'prettier-js-mode)
(add-hook 'scss-mode-hook 'prettier-js-mode)

;; eslint-fix
(add-hook 'js2-mode-hook 'eslintd-fix-mode)

;; Auto refresh files
(global-auto-revert-mode t)

;; Disable confirmation on exit
(setq confirm-kill-emacs nil)

;; Toggle maximize
(defun toggle-maximize-buffer () "Maximize buffer"
  (interactive)
  (if (= 1 (length (window-list)))
      (jump-to-register '_)
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))

;; TypeScript REPL
(add-hook 'typescript-mode-hook
          (lambda ()
            (local-set-key (kbd "C-x C-e") 'ts-send-last-sexp-and-go)))

;; Company mode  delay
(setq company-idle-delay 0)

;; Mac Command key as Control
(setq mac-command-modifier 'control)

;; Go
(eval-after-load 'flycheck '(add-hook 'flycheck-mode-hook #'flycheck-golangci-lint-setup))
