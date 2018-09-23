FROM php:7.1-fpm

RUN apt-get update && apt-get install --no-install-recommends -y vim unzip git libmcrypt-dev libpq-dev libxml2-dev \
    libcurl4-gnutls-dev curl zlib1g-dev \
    && docker-php-ext-install mcrypt pdo pgsql pdo_pgsql mbstring xml curl soap zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set user deployer
RUN useradd -g 33 -m deployer && echo "deployer:deployer" | chpasswd && adduser deployer sudo
RUN usermod -aG www-data deployer
RUN echo "deployer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN chown www-data:www-data /var/www -R
RUN chown deployer:www-data /usr/bin/composer
USER deployer
WORKDIR /home/deployer

