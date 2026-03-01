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

;; Link helper
(define (link url . text)
  `(a ((href ,url)) ,@text))

;; Project card
(define (project url name status img . description)
  `(div ((class "project"))
     (img ((src ,img) (alt ,name) (class "project-logo")))
     (h3 (a ((href ,url)) ,name))
     (p ((class "project-desc")) ,@description)
     (p ((class "project-status")) (span ((class "pink")) "Status: ") (em ,status) " · Written in " (a ((href "https://gleam.run/")) "Gleam"))))

;; Talk entry
(define (talk event-url event-name date slides-url . title)
  `(div ((class "talk"))
     (div ((class "talk-header"))
       (a ((href ,event-url) (class "talk-venue")) ,event-name)
       (span ((class "talk-date")) ,date))
     (p ((class "talk-title")) ,@title)
     (p ((class "talk-media")) (a ((href ,slides-url)) "Slides \u2197"))))
