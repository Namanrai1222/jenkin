FROM nginxinc/nginx-unprivileged:1.28.0-alpine

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 8080
