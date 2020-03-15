FROM php:5.6-fpm-stretch

# Container containing php-fpm and php-cli to run and interact with eZ Platform and other Symfony projects
#
# It has two modes of operation:
# - (run.sh cmd) [default] Reconfigure eZ Platform/Publish based on provided env variables and start php-fpm
# - (bash|php|composer) Allows to execute composer, php or bash against the image

# Set defaults for variables used by run.sh
ENV COMPOSER_HOME=/root/.composer

# Get packages that we need in container
RUN apt-get update -q -y \
    && apt-get install -q -y --no-install-recommends \
        ca-certificates \
        curl \
        acl \
        jq \
        sudo \
# Needed for the php extensions we enable below
        libfreetype6 \
        libjpeg62-turbo \
        libxpm4 \
        libpng16-16 \
        libpq-dev \
        libpq5 \
        libicu57 \
        libxslt1.1 \
        libmemcachedutil2 \
        imagemagick \
# git & unzip needed for composer, unless we document to use dev image for composer install
# unzip needed due to https://github.com/composer/composer/issues/4471
        unzip \
        git \
    && rm -rf /var/lib/apt/lists/*

# Install and configure php plugins
RUN set -xe \
    && buildDeps=" \
        $PHP_EXTRA_BUILD_DEPS \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libxpm-dev \
        libpng-dev \
        libicu-dev \
        libxslt1-dev \
        libmemcached-dev \
        libxml2-dev \
    " \
	&& apt-get update -q -y && apt-get install -q -y --no-install-recommends $buildDeps && rm -rf /var/lib/apt/lists/* \
# Extract php source and install missing extensions
    && docker-php-source extract \
    && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-xpm-dir=/usr/include/ --enable-gd-jis-conv \
    && docker-php-ext-install exif gd mbstring intl xsl zip mysqli pdo_mysql soap bcmath \
    && docker-php-ext-enable opcache \
    && cp /usr/src/php/php.ini-production ${PHP_INI_DIR}/php.ini \
    \
# Install blackfire: https://blackfire.io/docs/integrations/docker
#    && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
#    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
#    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
#    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
#    && rm -f /tmp/blackfire-probe.tar.gz \
#    \
# Install igbinary (for more efficient serialization in redis/memcached)
#    && for i in $(seq 1 3); do pecl install -o igbinary-2.0.8 && s=0 && break || s=$? && sleep 1; done; (exit $s) \
#    && docker-php-ext-enable igbinary \
#    \
# Install redis (manualy build in order to be able to enable igbinary)
#    && for i in $(seq 1 3); do pecl install -o --nobuild redis-4.3.0 && s=0 && break || s=$? && sleep 1; done; (exit $s) \
#    && cd "$(pecl config-get temp_dir)/redis" \
#    && phpize \
#    && ./configure --enable-redis-igbinary \
#    && make \
#    && make install \
#    && docker-php-ext-enable redis \
#    && cd - \
#    \
# Install memcached (manualy build in order to be able to enable igbinary)
#    && for i in $(seq 1 3); do echo no | pecl install -o --nobuild memcached-2.2.0 && s=0 && break || s=$? && sleep 1; done; (exit $s) \
#    && cd "$(pecl config-get temp_dir)/memcached" \
#    && phpize \
#    && ./configure --enable-memcached-igbinary \
#    && make \
#    && make install \
#    && docker-php-ext-enable memcached \
#    && cd - \
#    \
# Install Postgres support
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && cd - \
    \
# Delete source & builds deps so it does not hang around in layers taking up space
#    && pecl clear-cache \
#    && rm -Rf "$(pecl config-get temp_dir)/*" \
    && docker-php-source delete \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps

# Set timezone
RUN echo "UTC" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# Set pid file to be able to restart php-fpm
RUN sed -i "s@^\[global\]@\[global\]\n\npid = /run/php-fpm.pid@" ${PHP_INI_DIR}-fpm.conf

#COPY conf.d/blackfire.ini ${PHP_INI_DIR}/conf.d/blackfire.ini

# Create Composer directory (cache and auth files) & Get Composer
RUN mkdir -p $COMPOSER_HOME \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# As application is put in as volume we do all needed operation on run
COPY scripts /scripts

# Add some custom config
COPY conf.d/php.ini ${PHP_INI_DIR}/conf.d/php.ini
RUN chmod 755 /scripts/*.sh

# Needed for docker-machine
# RUN usermod -u 1000 www-data

WORKDIR /var/www

COPY composer.json composer.lock /var/www/

# the following variable exists only during build-time
# pass the correct value during build:
#     $ docker build --build-arg github_token=abcdef123456 # [...]
#
# ARG GITHUB_TOKEN=abcdef123456
# Avoid the following line, because leave the environment variable
# in the final image
# ENV GITHUB_TOKEN=$github_token
# The secure way to do it is to prepend the command with the variable definition:

# RUN curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/rate_limit

ENV COMPOSER_ALLOW_SUPERUSER=1
RUN echo "Running composer"  \
	&& composer global require hirak/prestissimo 
# RUN composer global config github-oauth.github.com "$GITHUB_TOKEN"
# RUN cat /root/.composer/auth.json
RUN composer install -vvv --prefer-dist --no-scripts --no-dev  
RUN rm -rf /root/.composer 
	
# Add consul client to allow configuration using consul KV store
COPY --from=consul:1.6 /bin/consul /bin/consul

# Add custom settings of prototipo
COPY conf.d/ez /var/www/html/settings
COPY conf.d/ez/cluster-config/config_cluster_trentoservizipubblici.php /var/www/html/config_cluster_trentoservizipubblici.php


WORKDIR /var/www/html

RUN php bin/php/ezpgenerateautoloads.php -e

WORKDIR /var/www

ENTRYPOINT ["/scripts/docker-entrypoint.sh"]

CMD php-fpm

EXPOSE 9000