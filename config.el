;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-one-light)

(setq display-line-numbers-type 'relative)

(after! company
  (setq company-idle-delay nil))

;;; :editor evil
;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;;; :tools lsp
;; Disable invasive lsp-mode features
(after! lsp-mode
  (setq lsp-enable-symbol-highlighting nil
        lsp-enable-suggest-server-download nil))
(after! lsp-ui
  (setq lsp-ui-sideline-enable nil  ; no more useful than flycheck
        lsp-ui-doc-enable nil))     ; redundant with K

(setq org-directory "~/Dropbox/org/")

(after! org
  (setq org-startup-folded 'show2levels
        org-ellipsis " [...] "
        org-capture-templates
        '(("n" "Notes" entry (file+headline "~/Dropbox/org/inbox.org" "Inbox")
           "* %?\n %i\n %a")
          ("b" "Bookmarks" entry (file+headline "~/Dropbox/org/notes.org" "Bookmarks")
           "** %(org-cliplink-capture)%?\n" :unnarrowed t)
          )))

(require 'org-bullets)
(add-hook 'org-mode-hook #'org-bullets-mode)

;;; :ui doom-dashboard
(setq fancy-splash-image (file-name-concat doom-user-dir "splash.png"))
;; Hide the menu for as minimalistic a startup screen as possible.
;; (setq +doom-dashboard-functions '(doom-dashboard-widget-banner))

;;; :app everywhere
(after! emacs-everywhere
  ;; Easier to match with a bspwm rule:
  ;;   bspc rule -a 'Emacs:emacs-everywhere' state=floating sticky=on
  (setq emacs-everywhere-frame-name-format "emacs-anywhere")

  ;; The modeline is not useful to me in the popup window. It looks much nicer
  ;; to hide it.
  (remove-hook 'emacs-everywhere-init-hooks #'hide-mode-line-mode)

  ;; Semi-center it over the target window, rather than at the cursor position
  ;; (which could be anywhere).
  (defadvice! center-emacs-everywhere-in-origin-window (frame window-info)
    :override #'emacs-everywhere-set-frame-position
    (cl-destructuring-bind (x y width height)
        (emacs-everywhere-window-geometry window-info)
      (set-frame-position frame
                          (+ x (/ width 2) (- (/ width 2)))
                          (+ y (/ height 2))))))
