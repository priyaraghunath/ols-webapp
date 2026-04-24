FROM litespeedtech/openlitespeed:latest

RUN apt-get update && apt-get install -y wget unzip curl

WORKDIR /var/www/vhosts/localhost/html

RUN rm -rf * \
    && wget https://wordpress.org/latest.zip \
    && unzip latest.zip \
    && mv wordpress/* . \
    && rm -rf wordpress latest.zip

RUN cp wp-config-sample.php wp-config.php && \
    sed -i "s/database_name_here/\${WORDPRESS_DB_NAME}/" wp-config.php && \
    sed -i "s/username_here/\${WORDPRESS_DB_USER}/" wp-config.php && \
    sed -i "s/password_here/\${WORDPRESS_DB_PASSWORD}/" wp-config.php && \
    sed -i "s/localhost/\${WORDPRESS_DB_HOST}/" wp-config.php

ENV WORDPRESS_DB_HOST=placeholder
ENV WORDPRESS_DB_USER=placeholder
ENV WORDPRESS_DB_PASSWORD=placeholder
ENV WORDPRESS_DB_NAME=wordpress

RUN echo "OK" > /var/www/vhosts/localhost/html/health

RUN chown -R lsadm:lsadm /var/www/vhosts/

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD curl -f http://localhost/health || exit 1
#testingthepipeline
EXPOSE 80