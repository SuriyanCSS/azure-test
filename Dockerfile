FROM httpd:latest
RUN apt update -y
WORKDIR /var/www/html
EXPOSE 80
CMD ["/usr/local/apache2", "-D", "FOREGROUND"]
