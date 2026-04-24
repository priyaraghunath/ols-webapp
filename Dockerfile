FROM litespeedtech/openlitespeed:latest

RUN apt-get update && apt-get install -y wget unzip

WORKDIR /var/www/vhosts/localhost/html

RUN rm -rf * \
    && wget https://wordpress.org/latest.zip \
    && unzip latest.zip \
    && mv wordpress/* . \
    && rm -rf wordpress latest.zip

# Wire DB credentials from environment variables into wp-config at runtime
RUN cp wp-config-sample.php wp-config.php && \
    sed -i "s/database_name_here/\${WORDPRESS_DB_NAME}/" wp-config.php && \
    sed -i "s/username_here/\${WORDPRESS_DB_USER}/" wp-config.php && \
    sed -i "s/password_here/\${WORDPRESS_DB_PASSWORD}/" wp-config.php && \
    sed -i "s/localhost/\${WORDPRESS_DB_HOST}/" wp-config.php

# Declare runtime env vars (actual values injected by ECS task definition)
ENV WORDPRESS_DB_HOST=placeholder
ENV WORDPRESS_DB_USER=placeholder
ENV WORDPRESS_DB_PASSWORD=placeholder
ENV WORDPRESS_DB_NAME=wordpress

# Health check endpoint
RUN echo "OK" > /var/www/vhosts/localhost/html/health

RUN chown -R lsadm:lsadm /var/www/vhosts/

# ECS uses this to determine container health before routing traffic
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD curl -f http://localhost/health || exit 1

EXPOSE 80