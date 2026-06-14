#lang racket/base

(require pollen/decode pollen/tag txexpr racket/string)
(provide (all-defined-out))

(module setup racket/base
  (provide (all-defined-out))
  (require racket/runtime-path racket/path)
  (define poly-targets '(html))
  ;; Pollen's cache keys off each page's mtime, its template, and pollen.rkt —
  ;; but NOT modules pulled in via ◊(require ...). Watch every project card so
  ;; editing projects/*.rkt invalidates the cache and the page re-renders.
  (define-runtime-path projects-dir "projects")
  (define cache-watchlist
    (for/list ([f (in-directory projects-dir)]
               #:when (path-has-extension? f #".rkt"))
      f)))

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

;; Project card. Each project lives in its own file under projects/ and calls
;; this to produce its card; index.html.pm requires those files and drops the
;; cards in. Description is the rest arg so markup (em, link, …) still works.
(define (project #:url url
                 #:name name
                 #:status status
                 #:img img
                 #:lang lang
                 #:lang-url lang-url
                 #:adoption [adoption #f]
                 . description)
  `(div ((class "project"))
     (img ((src ,img) (alt ,name) (class "project-logo")))
     (h3 (a ((href ,url)) ,name))
     (p ((class "project-desc")) ,@description)
     (p ((class "project-status"))
        (span ((class "pink")) "Status: ") (em ,status)
        ,@(if adoption
              `(" · " (span ((class "pink")) "Adoption: ") (em ,adoption))
              '())
        " · Written in " (a ((href ,lang-url)) ,lang))))

;; Datadog dashboard embed
(define (datadog-embed src)
  `(div ((class "status-embed"))
     (iframe ((src ,src)
              (title "Brickell Research status dashboard")
              (loading "lazy")))))

;; -------- Notebook tags --------

;; Right-margin aside (becomes inline callout on narrow screens)
(define (aside . body)
  `(aside ,@body))

;; Aside with vertical alignment to a nearby paragraph: ◊aside-up[2]{...}
(define (aside-up n . body)
  `(aside ((class "move-up") (style ,(format "--move-up: ~a" n))) ,@body))

;; Figure — clean cyan-framed media. Use for diagrams, screenshots, charts.
(define (figure src . caption)
  `(figure (img ((src ,src) (alt "")))
           (figcaption ,@caption)))

;; Sketch — "photo of paper" variant with offset pink-tinted shadow.
(define (sketch src . caption)
  `(figure ((class "sketch"))
           (img ((src ,src) (alt "")))
           (figcaption ,@caption)))

;; Video demo — autoplays muted, loops, playsinline. Use for screen recordings.
(define (video src)
  `(figure (video ((src ,src) (controls "") (playsinline "")
                   (preload "metadata") (muted "") (loop "")))))

;; Per-note byline + backlink, dropped at the top of every entry.
(define (note-meta date)
  `(p ((class "note-meta"))
     (time ((datetime ,date)) ,date)
     " · "
     (a ((href "/notes")) "← all notes")))

;; A single entry in a dated note list — used on both /notes and the home page.
(define (note date href . title)
  `(li ((class "note-item"))
       (time ((datetime ,date)) ,date)
       (a ((href ,href)) ,@title)))

;; Container for a list of notes.
(define (note-list . items)
  `(ul ((class "note-index")) ,@items))

;; Inline code — for tag names, types, identifiers in prose.
(define (code . body)
  `(code ,@body))

;; Code block — preserves whitespace and indentation literally.
;; CONVENTION: write the body with leading + trailing newlines, like:
;;   ◊code-block{
;;   first line of code
;;     indented line
;;   }
;; This bypasses Scribble's leading-line dedent (which strips a variable
;; amount based on the first content line's shape). The function trims the
;; sentinel newlines back off.
(define (code-block . body)
  (let* ([raw (apply string-append
                     (map (lambda (x) (if (string? x) x "")) body))]
         [trimmed (string-trim raw "\n" #:repeat? #t)])
    `(pre ((class "code-block")) (code ,trimmed))))
