#Uses the minimalistic Alpine Linux image version 3.17.5 as the base image
FROM alpine:3.17.5

#Declare arguments that can be passed when building the image. 
#This is done to set environment variables and pass values at build time
ARG PHP_VERSION=81 \
    DB_NAME \
    DB_USER \
    DB_PASS \
    DB_ROOT \
    WP_ADUSER \
    WP_ADPASS \
    WP_ADEMAIL \
    WP_USER1 \
    WP_PASS1 \
    WP_EMAIL1

#A number of packages are installed, including PHP and its extensions, as well as wget and unzip. 
#This is required for WordPress and its dependencies to work
RUN apk update && apk upgrade && apk add --no-cache \
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-phar \
    wget \
    unzip && \
    #These commands change the configuration files for PHP-FPM so that it 
    #listens on port 9000 and has the correct owners and groups. 
    #This is done to ensure that PHP-FPM works correctly in the container
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" \
      /etc/php81/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
      /etc/php81/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
      /etc/php81/php-fpm.d/www.conf && \
    rm -f /var/cache/apk/*

#Sets the working directory to /var/www. 
#This is for convenience, so that subsequent commands will be executed in this directory
WORKDIR /var/www

#Downloads the WP-CLI utility, makes it executable and moves it to /usr/local/bin/wp. 
#This is needed to manage WordPress via the command line
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

#Downloads and installs WordPress. 
#The --force and --allow-root parameters are needed to make the operation 
#run even if WordPress is already installed and run as root user
RUN php -d memory_limit=512M /usr/local/bin/wp core download --force --allow-root


#Copies the script to create the WordPress configuration to the working directory. 
#This is done to automatically configure WordPress
COPY ./requirements/wordpress/conf/wp-config-create.sh .

#Copies the WordPress initialization script to /usr/local/bin. 
#This script will be run when the container is started
COPY ./requirements/wordpress/conf/wp-init.sh /usr/local/bin

#Gives the wp-init.sh script execution rights. 
#This is done so that the script can be run
RUN chmod 777 /usr/local/bin/wp-init.sh

# Runs a script that creates a WordPress configuration file and deletes it after use. 
# Also changes permissions on the wp-content directory
RUN sh wp-config-create.sh && rm wp-config-create.sh && \
    chmod -R 0777 wp-content/

#Opens port 9000 in the container. This is done to communicate with PHP-FPM
EXPOSE 9000

#Runs the wp-init.sh script when the container starts. 
#This script will initialize WordPress if necessary.
CMD ["/usr/local/bin/wp-init.sh"]