FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y mariadb-server

COPY ./tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

EXPOSE 3306

ENTRYPOINT [ "/tmp/setup.sh" ]

CMD ["mysqld_safe"]