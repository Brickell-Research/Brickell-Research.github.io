#lang racket

(require web-server/web-server
         web-server/servlet-env
         web-server/http/request-structs
         web-server/http/response-structs
         net/url
         racket/runtime-path
         racket/base
         racket/file)

;; Serve ./public (with index.html as default)
(define-runtime-path PUBLIC_DIR "public")

(define PORT 8005)

;; Simple request handler that serves static files
(define (my-handler req)
  (define uri (request-uri req))
  (define path-parts (url-path uri))
  (define path-string
    (if (null? path-parts)
        "/"
        (string-append "/" (string-join (map path/param-path path-parts) "/"))))
  (define file-path
    (cond
      [(or (string=? path-string "/") (string=? path-string ""))
       (build-path PUBLIC_DIR "index.html")]
      [else
       (build-path PUBLIC_DIR (substring path-string 1))]))

  (if (file-exists? file-path)
      (response/full 200 #"OK" (current-seconds) #"text/html" '()
                     (list (file->bytes file-path)))
      (response/full 404 #"Not Found" (current-seconds) #"text/plain" '()
                     (list #"File not found"))))

(serve/servlet my-handler
               #:port PORT
               #:listen-ip #f
               #:servlet-path "/"
               #:servlet-regexp #rx"")
