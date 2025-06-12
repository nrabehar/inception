FROM debian:bullseye-slim

# FTP server installation
RUN apt-get update && \
		apt-get install -y vsftpd

# Create necessary directories
RUN mkdir -p /var/run/vsftpd /var/log/vsftpd

COPY ./tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

EXPOSE 21 20

ENTRYPOINT [ "/tmp/setup.sh" ]

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]