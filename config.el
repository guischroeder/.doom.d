;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;
;;; UI

(setq doom-theme 'doom-one
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


;;
;;; RoR stuff

;; only check syntax on save and disable ruby-reek
(setq-default flycheck-disabled-checkers '(ruby-reek))
(setq flycheck-disabled-checkers '(ruby-reek))

;; solargraph
;; (use-package lsp-mode
;;   :ensure t
;;   :commands (lsp lsp-deferred)
;;   :hook ((ruby-mode . lsp)
;;          (enh-ruby-mode . lsp))
;;   :init
;;   (setq lsp-solargraph-use-bundler t)
;;   (setq lsp-solargraph-diagnostics t)
;;   (setq lsp-solargraph-formatting t))

;; Disable RuboCop in Flycheck for Ruby/Rails projects
(after! flycheck
  (setq-default flycheck-disabled-checkers '(ruby-rubocop)))
;; Disable RuboCop in lsp-mode for Ruby/Rails
;; (after! lsp-ruby
;;   (setq lsp-solargraph-diagnostics nil))


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

;;

;; slime
(setq inferior-lisp-program "sbcl")

(defun my-slime-repl-bindings ()
  "Custom key bindings for SLIME REPL."
  (define-key slime-repl-mode-map (kbd "<up>") 'slime-repl-previous-input)
  (define-key slime-repl-mode-map (kbd "<down>") 'slime-repl-next-input))

(add-hook 'slime-repl-mode-hook 'my-slime-repl-bindings)
;;

;; copilot
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(after! (evil copilot)
  ;; Define the custom function that either accepts the completion or does the default behavior
  (defun my/copilot-tab-or-default ()
    (interactive)
    (if (and (bound-and-true-p copilot-mode)
             ;; Add any other conditions to check for active copilot suggestions if necessary
             )
        (copilot-accept-completion)
      (evil-insert 1))) ; Default action to insert a tab. Adjust as needed.

  ;; Bind the custom function to <tab> in Evil's insert state
  (evil-define-key 'insert 'global (kbd "<tab>") 'my/copilot-tab-or-default))
