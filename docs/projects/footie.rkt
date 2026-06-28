#lang racket/base

;; Footie project card. Edit the fields below in isolation.
(require "../pollen.rkt")
(provide footie)

(define footie
  (project
   #:url    "https://github.com/Brickell-Research/footie"
   #:name   "Footie"
   #:status "Early Development"
   #:img    "/footie.svg"
   #:lang   "Rhombus, Gleam & Rust"
   ;; Description — plain strings, with markup as txexprs / link helper:
   "A niche, agentic system for interpreting football games. A Rhombus DSL — "
   '(em "footie-lang") " — describes on-pitch actions, lightweight Gleam agents "
   "translate real events into it, and a Rust warehouse powers the offline "
   "analysis and inference models. "
   (link "https://github.com/Brickell-Research/footie" "On GitHub") "."))
