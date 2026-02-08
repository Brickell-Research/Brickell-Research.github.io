#lang racket/base

(require pollen/decode pollen/tag txexpr)
(provide (all-defined-out))

(module setup racket/base
  (provide (all-defined-out))
  (define poly-targets '(html)))

;; Root function — auto-wraps paragraphs
(define (root . elements)
  `(div ,@(decode-elements elements
            #:txexpr-elements-proc decode-paragraphs)))

;; Color helpers
(define (cyan . text)
  `(span ((class "cyan")) ,@text))

(define (pink . text)
  `(span ((class "pink")) ,@text))

;; List helpers
(define (ul . items)
  `(ul ,@items))

(define (li . text)
  `(li ,@text))

;; Link helper
(define (link url . text)
  `(a ((href ,url)) ,@text))
