FROM nginx:latest
COPY ${WORKSPACE}/index.html /usr/share/nginx/html/index.html
