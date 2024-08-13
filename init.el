;;; init.el -*- lexical-binding: t; -*-
;;;

(doom! :completion
       corfu
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
       format
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
       (lookup +docsets +dictionary)
       lsp
       magit
       tree-sitter

       :os
       (:if IS-MAC macos)

       :lang
       ;;(cc +lsp)
       ;;clojure
       ;;crystal
       ;;elixir
       ;;elm
       emacs-lisp
       ;;erlang
       ;;(go +lsp)
       (graphql +lsp)
       ;;(haskell +lsp)
       json
       ;;(java +lsp)
       (javascript)
       markdown
       ;;ocaml
       (org +pretty +journal)
       org
       ;;(python +lsp)
       rest
       (ruby +rails)
       ;;(rust +lsp)
       sh
       (web +lsp +tree-sitter)
       yaml
       ;;zi

       :app
       everywhere

       :config
       (default +bindings +smartparens))
