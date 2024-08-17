;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;
;;; UI

(setq doom-theme 'doom-solarized-dark
      doom-font (font-spec :family "JetBrainsMono" :size 16))
(setq display-line-numbers-type 'relative)
;; hide the menu in the startup
(setq +doom-dashboard-functions '(doom-dashboard-widget-banner))
;; prevents some cases of Emacs flickering.
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))


;;
;;; Keybindings

(map! (:leader (:prefix "k" :desc "Insert image from clipboard" "i" #'org-insert-clipboard-image)))
(defun org-insert-clipboard-image ()
  (interactive)
  ;; -n removes empty new line after uuidgen
  (setq file (concat (concat (concat org-img-directory "/") (shell-command-to-string "echo -n `uuidgen`")) ".png"))

  (shell-command (concat "xclip -selection clipboard -t image/png -o >" file))
  (insert (concat "[[" file "]]"))
  (org-display-inline-images))


;;
;;; Modules

;;; :editor evil
;; focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)
;; implicit /g flag
(setq evil-ex-substitute-global t)

;;; :orderless
;; use fuzzy matching without order
(setq orderless-matching-styles '(orderless-flex orderless-regexp))

;;; :lang org
(after! org
  (setq org-startup-folded 'show2levels
        org-ellipsis " [...] "
        org-capture-templates
        '(("t" "todo" entry (file "~/Dropbox/org/todo.org")
           "* TODO %?\nCREATED: %U\n")
          ("n" "note" entry (file+headline "~/Dropbox/org/notes.org" "Inbox")
           "* %?")
          ("s" "schedule" entry (file  "~/Dropbox/org/todo.org")
           "* TODO %?\nSCHEDULED: <%(org-read-date)>\n\n%i\n%a")
        ))
  (setq org-todo-keywords '
        ((sequence "TODO(t)" "STRT(s)" "WAIT(w@/!)" "|" "DONE(d/!)"))))

(setq org-directory "~/Dropbox/org")
(setq org-img-directory "~/Dropbox/org/img")
