;;; init.el -*- lexical-binding: t; -*-

(doom! :completion
       company
       (vertico +icons)

       :ui
       doom
       doom-dashboard
       hl-todo
       modeline
       ophints
       (popup +defaults)
       (vc-gutter +diff-hl +pretty)
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       ;; (format +onsave)
       multiple-cursors
       snippets

       :emacs
       dired
       electric
       undo
       vc

       :term
       eshell
       vterm

       :checkers
       syntax

       :tools
       direnv
       editorconfig
       (eval +overlay)
       gist
       (lookup +docsets +dictionary)
       lsp
       magit
       pdf
       tree-sitter

       :os
       (:if IS-MAC macos)

       :lang
       (cc +lsp)
       clojure
       ;;crystal
       ;;elixir
       ;;elm
       emacs-lisp
       ;;erlang
       (go +lsp)
       ;;(graphql +lsp)
       ;;(haskell +lsp)
       json
       ;;(java +lsp)
       (javascript +lsp)
       ;;kotlin
       ;;lean
       ;;lua
       markdown
       ;;ocaml
       (org +journal)
       ;;(python +lsp)
       ;;rest
       (ruby +rails)
       ;;(rust +lsp)
       sh
       web
       yaml
       ;;zig

       :email
       ;;(mu4e +org +gmail)
       ;;notmuch
       ;;(wanderlust +gmail)

       :app
       ;;calendar
       everywhere

       :config
       ;;literate
       (default +bindings +smartparens))
