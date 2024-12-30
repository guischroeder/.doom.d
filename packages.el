;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! orderless)
(package! slime)
(package! copilot-chat)
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))
