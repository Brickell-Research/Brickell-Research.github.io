#lang racket/base

;; Manatee project card. Edit the fields below in isolation.
(require "../pollen.rkt")
(provide manatee)

(define manatee
  (project
   #:url      "https://github.com/Brickell-Research/manatee"
   #:name     "Manatee"
   #:status   "Active Development"
   #:img      "/manatee_logo.png"
   #:lang     "Gleam"
   #:lang-url "https://gleam.run/"
   #:adoption "Experimental"
   ;; Description — plain strings, with markup as txexprs / link helper:
   "A small runtime and DSL for analyzing the reliability of agentic systems. Specifically focused on the concept of non-determinism creep and compounding uncertainty (a.k.a. tolerance stacking in more traditional mechanical engineering)."))
