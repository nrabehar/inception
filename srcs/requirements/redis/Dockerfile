FROM debian:bullseye-slim

RUN apt-get update && \
	apt-get install -y redis-server

RUN mkdir -p /var/lib/redis /run/redis
WORKDIR /var/lib/redis
RUN sed -i 's/^bind 127.0.0.1 ::1/bind 0.0.0.0/' /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]