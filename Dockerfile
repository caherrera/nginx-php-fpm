FROM nginx:1.21.3
COPY ./docker-entrypoint.d/20-1-pre-envsubst-on-templates.sh /docker-entrypoint.d/20-1-pre-envsubst-on-templates.sh
COPY ./etc/nginx/templates/default.conf.template /etc/nginx/templates/default.conf.template
COPY ./etc/nginx/php.conf /etc/nginx/php.conf
ENV NGINX_ROOT='/var/www/html'
