FROM debian:bullseye-slim

RUN apt-get update && \
	apt-get install -y php7.4-fpm php7.4-mysql curl\
	php7.4-curl php7.4-dom php7.4-imagick \
	php7.4-mbstring php7.4-zip php7.4-gd php7.4-intl

RUN mkdir -p /var/www/html/wp /run/php

WORKDIR /var/www/html/wp

RUN sed -i 's/listen = .*/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh


EXPOSE 9000

ENTRYPOINT [ "/tmp/setup.sh" ]
CMD ["php-fpm7.4", "-F"]
