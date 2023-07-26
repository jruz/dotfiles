;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! git-gutter)
;(package! disable-mouse)
(package! string-inflection)
(package! eslintd-fix)
(package! terraform-mode)
(package! typescript-mode)
(package! tide)
(package! prettier-js)
(package! dockerfile-mode)
(package! docker-compose-mode)
(package! ts-comint)
(package! rescript-mode)
;; (package! showkey)
(package! copilot
  :recipe (:host github :repo "zerolfx/copilot.el" :files ("*.el" "dist")))
(package! catppuccin-theme)
