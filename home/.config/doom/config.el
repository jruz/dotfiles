;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; theme
(setq doom-theme 'doom-molokai)
;;(setq doom-theme 'catppuccin)
;(setq catppuccin-flavor 'mocha)
;(catppuccin-reload)
;; background color
;(add-to-list 'default-frame-alist '(background-color . "#1d1f21"))

;; font size
(set-face-attribute 'default t :font "Inconsolata")
(setq doom-unicode-font (font-spec :family "Apple Color Emoji"))

;; line numbers
(setq display-line-numbers-type "relative")

;; tabs
(setq-default tab-width 2)

;; word wrap
(global-visual-line-mode t)

;; disable-mouse
;(require 'disable-mouse)
;(global-disable-mouse-mode)
;(mapc #'disable-mouse-in-keymap
;  (list evil-motion-state-map
;        evil-normal-state-map
;        evil-visual-state-map
;        evil-insert-state-map))

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
;(add-hook 'typescript-mode-hook
;          (lambda ()
;            (local-set-key (kbd "C-x C-e") 'ts-send-last-sexp-and-go)))

;; Company mode  delay
(setq company-idle-delay 0)

;; Mac Command key as Control
(setq mac-command-modifier 'control)

;; Copilot
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
