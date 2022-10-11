FROM ubuntu:18.04
RUN apt update -y
WORKDIR /var/www/html
#EXPOSE 443
#CMD ["/usr/local/apache2", "-D", "FOREGROUND"]
