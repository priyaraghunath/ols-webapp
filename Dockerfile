FROM litespeedtech/openlitespeed:latest

RUN apt-get update && apt-get install -y wget unzip curl

WORKDIR /var/www/vhosts/localhost/html

RUN rm -rf * \
    && wget https://wordpress.org/latest.zip \
    && unzip latest.zip \
    && mv wordpress/* . \
    && rm -rf wordpress latest.zip

RUN cp wp-config-sample.php wp-config.php

RUN echo "OK" > /var/www/vhosts/localhost/html/health

RUN chown -R lsadm:lsadm /var/www/vhosts/

ENV WORDPRESS_DB_HOST=placeholder
ENV WORDPRESS_DB_USER=placeholder
ENV WORDPRESS_DB_PASSWORD=placeholder
ENV WORDPRESS_DB_NAME=wordpress

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD curl -f http://localhost/health || exit 1

EXPOSE 80

# Override the original entrypoint to inject DB credentials first
COPY wp-entrypoint.sh /wp-entrypoint.sh
RUN chmod +x /wp-entrypoint.sh
ENTRYPOINT ["/wp-entrypoint.sh"]