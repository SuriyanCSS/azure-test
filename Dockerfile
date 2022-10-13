FROM composer:2.2 AS build
WORKDIR /tmp/
#COPY composer.json composer.json
RUN composer install --ignore-platform-reqs

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive 

RUN apt update
RUN apt install -y nginx 
RUN apt install -y php7.4 curl sudo gpg apt-utils && apt install -y php7.4-fpm && apt install -y supervisor
RUN curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh
RUN adduser -u 1002 app-user --disabled-password
ENV newrelicmetricapi metric-api.eu.newrelic.com
ENV newrelickey eu01xx2696e2caa0f935cb119b2dca065ad0NRAL
ENV sitename xyz.com
ENV environment prod
ENV testlog /opt/testlog
ENV newreliclogapi https://log-api.eu.newrelic.com/log/v1
ENV logname applog

COPY nginx.conf /etc/nginx/nginx.conf
COPY php_conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
COPY supervisor_conf/supervisor.conf /etc/supervisor/supervisor.conf
COPY fluent_bit  /etc/fluent_bit
WORKDIR /var/www/html/
COPY --from=build /tmp/vendor/ /var/www/html/vendor/
COPY index.php /var/www/html/index.php

RUN chown 1002:1002  /var/log/ /opt/fluent-bit/* /etc/fluent_bit/* /etc/nginx/* /etc/php/7.4/fpm/* /var/run/ /var/log/nginx/* /var/lib/nginx /var/run/*

EXPOSE 80
ENTRYPOINT ["/usr/bin/supervisord","-n","-c","/etc/supervisor/supervisor.conf"]
