FROM registry.n-os.org:5000/base-s6:0.1.0

LABEL maintainer="Robert Schumann <rs@n-os.org>"

RUN cleaninstall \
    nginx \
    php-curl \
    php-fpm \
    php-gd \
    php-intl \
    php-mysql \
    php-sqlite3 \
    php-memcached \
    php-mbstring \
    php-xml \
    php-zip \
    php-pear

# Install composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php \
    && mv composer.phar /usr/local/bin/composer

# Configure services
COPY manifest /

RUN rm -rf /etc/php/7.4/fpm/pool.d \
  && usermod -u 1000 -G staff www-data

# Overridable environment variables
ENV DOCUMENT_ROOT=/var/www \
    PHP_MEMORY_LIMIT=128M \
    PHP_ERROR_REPORTING="E_ALL & ~E_DEPRECATED & ~E_STRICT"

# Add a default (phpinfo) website
# WORKDIR ${DOCUMENT_ROOT}
# RUN rm -rf *
# COPY /usr/index.php ./

# Expose HTTP
EXPOSE 80
