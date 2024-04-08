;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-one
      doom-font (font-spec :size 18))

(setq display-line-numbers-type 'relative)

;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)
;;

(setq package-install-upgrade-built-in t)

(setq org-directory "~/Dropbox/org/")

(after! org
  (setq org-startup-folded 'show2levels
        org-ellipsis " [...] "
        org-capture-templates
        '(("t" "Todo" entry (file "~/Dropbox/org/todo.org")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n")))
  (setq org-todo-keywords '
        ((sequence "TODO(t)" "STRT(s)" "WAIT(w@/!)" "|" "DONE(d/!)"))))

;; Insert image from clipboard
(setq org-directory "~/Dropbox/org")
(setq org-img-directory "~/Dropbox/org/img")

(defun org-insert-clipboard-image ()
  (interactive)
  ;; -n removes empty new line after uuidgen
  (setq file (concat (concat (concat org-img-directory "/") (shell-command-to-string "echo -n `uuidgen`")) ".png"))

  (shell-command (concat "xclip -selection clipboard -t image/png -o >" file))
  (insert (concat "[[" file "]]"))
  (org-display-inline-images))

;; org-roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Dropbox/org/roam"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ;; ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture))
         ;; ;; Dailies
         ;; ("C-c n j" . org-roam-dailies-capture-today)
         ;; ("C-c n d" . org-roam-dailies-goto-today)
         ;; ("C-c n D" . org-roam-dailies-goto-date)
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(map! (:leader (:prefix "k" :desc "Insert image from clipboard" "i" #'org-insert-clipboard-image)))
;;

;; Fix https://github.com/doomemacs/doomemacs/issues/5714
(defadvice! +org--restart-mode-before-indirect-buffer-a (base-buffer &rest _)
    "Restart `org-mode' in buffers in which the mode has been deferred (see
`+org-defer-mode-in-agenda-buffers-h') before they become the base buffer for an
indirect buffer. This ensures that the buffer is fully functional not only when
the *user* visits it, but also when some code interacts with it via an indirect
buffer as done, e.g., by `org-capture'."
    :before #'make-indirect-buffer
    (with-current-buffer base-buffer
     (when (memq #'+org--restart-mode-h doom-switch-buffer-hook)
       (+org--restart-mode-h))))
;;

;; make SPC SPC find file with fuzzy matching by default

;; (setq orderless-matching-styles '(orderless-flex orderless-regexp))

;; enables evil inside a minibuffer, like in vertico
(setq evil-collection-setup-minibuffer t)
