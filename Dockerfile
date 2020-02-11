FROM debian:buster

COPY srcs/db.sql /tmp/
COPY srcs/wordpress.sql /tmp/

RUN apt update && \
		apt install -y vim nginx mariadb-server php-fpm php-mysql php-mbstring openssl && \
		chown -R www-data:www-data /var/www/* && \
		chmod -R 755 /var/www/* && \
		service mysql start && \
		mysql -u root --password= < /tmp/db.sql && \
		mysql wordpress -u root --password= < /tmp/wordpress.sql && \
		openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=127.0.0.1" \
		-keyout /etc/ssl/private/agianico.key \
		-out /etc/ssl/certs/agianico.crt && \
		openssl dhparam -out /etc/nginx/dhparam.pem 1000

COPY	srcs/wordpress /var/www/html/wordpress
COPY	srcs/phpmyadmin /var/www/html/phpmyadmin
COPY	srcs/default /etc/nginx/sites-available/
COPY	srcs/index.nginx-debian.html /var/www/html/

RUN		chown -R www-data:www-data /var/www/* && \
		chmod -R 755 /var/www/* 

CMD	service nginx start && \
	service mysql start && \
	service php7.3-fpm start && \
	bash
	
