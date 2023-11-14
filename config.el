;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-zenburn
      doom-font (font-spec :size 18))

(setq display-line-numbers-type 'relative)

;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

(setq org-directory "~/Dropbox/org/")

(after! org
  (setq org-startup-folded 'show2levels
        org-ellipsis " [...] "
        org-capture-templates
        '(("t" "Todo" entry (file "~/Dropbox/org/todo.org")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n")))
  (setq org-todo-keywords '
        ((sequence "TODO(t)" "STRT(s)" "WAIT(w@/!)" "|" "DONE(d/!)"))))

(setq fancy-splash-image (file-name-concat doom-user-dir "splash.png"))
