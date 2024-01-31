FROM php:8.1-fpm

# Create a non-root user and group
RUN groupadd -g 1000 appuser && useradd -u 1000 -g appuser -m -s /bin/bash appuser

# check https://github.com/mlocati/docker-php-extension-installer for other extensions
RUN apt-get update && apt-get install -y \
        # additional packages if needed
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions mysqli gd ssh2 zip imagick exif

ADD customPHPConf/  /usr/local/etc/php/conf.d/

WORKDIR /var/www/codebase
RUN chown -R appuser:appuser /var/www/codebase

# Adding docker entrypoint
ADD entrypoint.sh /opt/
RUN chmod 755 /opt/entrypoint.sh

# Switch to the new user
USER appuser

CMD ["/bin/bash","/opt/entrypoint.sh"]
