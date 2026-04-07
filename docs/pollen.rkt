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

;; Small/muted text
(define (small . text)
  `(span ((class "small")) ,@text))

;; Talk blurb
(define (blurb . text)
  `(span ((class "blurb")) ,@text))

;; Link helper
(define (link url . text)
  `(a ((href ,url)) ,@text))

;; Project card
(define (project url name status img lang lang-url . description)
  `(div ((class "project"))
     (img ((src ,img) (alt ,name) (class "project-logo")))
     (h3 (a ((href ,url)) ,name))
     (p ((class "project-desc")) ,@description)
     (p ((class "project-status")) (span ((class "pink")) "Status: ") (em ,status) " · Written in " (a ((href ,lang-url)) ,lang))))
