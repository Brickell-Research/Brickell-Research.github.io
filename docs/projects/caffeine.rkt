#lang racket/base

;; Caffeine project card. Edit the fields below in isolation.
(require "../pollen.rkt")
(provide caffeine)

(define caffeine
  (project
   #:url      "https://caffeine-lang.run/"
   #:name     "Caffeine"
   #:status   "Active Development"
   #:img      "https://caffeine-lang.run/images/temp_caffeine_icon.png"
   #:lang     "Gleam"
   #:lang-url "https://gleam.run/"
   #:adoption "Production (industry)"
   ;; Description — plain strings, with markup as txexprs / link helper:
   "A programming language for generating reliability artifacts from service "
   "expectation definitions. Grounded in assume/guarantee contracts, Caffeine "
   "helps developers and AI agents assert reasonable system construction at "
   "design time " '(em "and") " in production. We "
   (link "/status" "dogfood it") " here."))
