FROM base-s6:latest

LABEL maintainer="Robert Schumann <rs@n-os.org>"

# Install packages and clean up after apt
RUN cleaninstall \
    nginx \
    php-curl \
    php-fpm \
    php-gd \
    php-mysql \
    php-sqlite3 \
    php-mbstring \
    php-xml \
    php-zip

# Install composer
RUN php -r "readfile('https://getcomposer.org/installer');" | php \
    && mv composer.phar /usr/local/bin/composer

# Configure services
COPY etc /etc
RUN rm -rf /etc/php/7.3/fpm/pool.d

# Development workaround (boot2docker)
RUN usermod -u 1000 -G staff www-data

# Overridable environment variables
ENV DOCUMENT_ROOT=/var/www \
    PHP_MEMORY_LIMIT=128M \
    PHP_ERROR_REPORTING="E_ALL & ~E_DEPRECATED & ~E_STRICT"

# Add a default (phpinfo) website
WORKDIR ${DOCUMENT_ROOT}
RUN rm -rf *
COPY index.php ./

# Expose HTTP
EXPOSE 80
