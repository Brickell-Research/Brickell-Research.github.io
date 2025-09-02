# Use the official Racket image
FROM racket/racket:latest

WORKDIR /app

# Install required packages
RUN raco pkg install --auto web-server

COPY server.rkt .
COPY public ./public

EXPOSE 8005

CMD ["racket", "server.rkt"]
