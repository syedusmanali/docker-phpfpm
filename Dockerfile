FROM php:7.3-fpm

# check https://github.com/mlocati/docker-php-extension-installer for other extensions
RUN apt-get update
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions mysqli gd ssh2 zip imagick exif

ADD customPHPConf/  /usr/local/etc/php/conf.d/

WORKDIR /var/www/codebase
RUN chown -R www-data:www-data /var/www/codebase

#Adding docker entrypoint
ADD entrypoint.sh /opt/
RUN chmod 755 /opt/entrypoint.sh

CMD ["/bin/bash","/opt/entrypoint.sh"]
