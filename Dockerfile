# Use the official Racket image
FROM racket/racket:latest

WORKDIR /app

COPY server.rkt .
COPY public ./public

EXPOSE 8005

CMD ["racket", "server.rkt"]
