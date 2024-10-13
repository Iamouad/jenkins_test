FROM nginx:latest
COPY ./index.html /usr/share/nginx/html/index.html
RUN sed -i "s/today/$(date)/g" /usr/share/nginx/html/index.html
