FROM nginx:alpine

# Copy your static HTML into nginx's default public directory
COPY index.html /usr/share/nginx/html/

# Expose nginx default port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

