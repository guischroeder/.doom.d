;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-solarized-dark
      doom-font (font-spec :family "JetBrainsMono" :size 16))

(setq display-line-numbers-type 'relative)

;; Disable doom dashboard menu
(setq +doom-dashboard-functions '(doom-dashboard-widget-banner))

;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; org-mode
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

(map! (:leader (:prefix "k" :desc "Insert image from clipboard" "i" #'org-insert-clipboard-image)))

;; make SPC SPC use fuzzy finding by default
(setq orderless-matching-styles '(orderless-flex orderless-regexp))

;; enables evil inside a minibuffer, like in vertico
(setq evil-collection-setup-minibuffer t)

;; :app everywhere
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

;; only check syntax on safe and disable ruby-reek
(setq-default flycheck-disabled-checkers '(ruby-reek))
(setq flycheck-disabled-checkers '(ruby-reek))

;; Set solargraph as lsp server
;; (use-package lsp-mode
;;   :ensure t
;;   :commands (lsp lsp-deferred)
;;   :hook ((ruby-mode . lsp)
;;          (enh-ruby-mode . lsp))
;;   :init
;;   (setq lsp-solargraph-use-bundler t)
;;   (setq lsp-solargraph-diagnostics t)
;;   (setq lsp-solargraph-formatting t))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; Some magic
(setq projectile-rails-expand-snippet-with-magic-comment t)

(defun my/snake-to-camel (string)
  "Convert STRING from snake case to camel case."
  (let ((case-fold-search nil))
    (mapconcat 'upcase-initials (split-string string "_") "")))

(defun my/projectile-rails-classify (name)
  "Split NAME by '/' character and classify each of the element."
  (--map (my/snake-to-camel it) (split-string name "/")))

(advice-add 'projectile-rails-classify :override #'my/projectile-rails-classify)

(defun my/projectile-rails-corresponding-snippet ()
  "Expand snippet appropriate for the current Rails file.
Call `projectile-rails--expand-snippet' with a snippet
corresponding to the current file."
  (let* ((name (buffer-file-name))
         (snippet
          (cond ((string-match "app/[^/]+/concerns/\\(.+\\)\\.rb$" name)
                 (format
                  "module %s\n  extend ActiveSupport::Concern\n  $0\nend"
                  (s-join "::" (projectile-rails-classify (match-string 1 name)))))
                ((string-match "app/controllers/\\(.+\\)\\.rb$" name)
                 (format
                  "class %s < ${1:ApplicationController}\n$2\nend"
                  (s-join "::" (projectile-rails-classify (match-string 1 name)))))
                ((string-match "app/jobs/\\(.+\\)\\.rb$" name)
                 (format
                  "class %s < ${1:ApplicationJob}\n$2\nend"
                  (s-join "::" (projectile-rails-classify (match-string 1 name)))))
                ((string-match "spec/[^/]+/\\(.+\\)_spec\\.rb$" name)
                 (format
                  "describe %s do\n  $0\nend"
                  (s-join "::" (projectile-rails-classify (match-string 1 name)))))
                ((string-match "app/models/\\(.+\\)\\.rb$" name)
                 (projectile-rails--snippet-for-model (match-string 1 name)))
                ((string-match "app/helpers/\\(.+\\)_helper\\.rb$" name)
                 (format
                  "module %sHelper\n$1\nend"
                  (s-join "::" (projectile-rails-classify (match-string 1 name)))))
                ((string-match "lib/\\(.+\\)\\.rb$" name)
                 (projectile-rails--snippet-for-module "${1:module} %s\n" (match-string 1 name)))
                ((string-match "app/\\(?:[^/]+\\)/\\(.+\\)\\.rb$" name)
                 (projectile-rails--snippet-for-module "${1:class} %s\n" (match-string 1 name))))))
    (if (and snippet projectile-rails-expand-snippet-with-magic-comment)
        (format "# frozen_string_literal: true\n\n%s" snippet)
      snippet)))

(advice-add 'projectile-rails-corresponding-snippet :override #'my/projectile-rails-corresponding-snippet)
