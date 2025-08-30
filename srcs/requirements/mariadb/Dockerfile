FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y mariadb-server procps

COPY ./conf/db.cnf /etc/mysql/mariadb.conf.d/99-custom.cnf

COPY ./tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

EXPOSE 3306

ENTRYPOINT [ "/tmp/setup.sh" ]