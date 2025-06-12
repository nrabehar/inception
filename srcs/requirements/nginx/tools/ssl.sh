#!/bin/bash
set -e

DOMAIN_NAME=${DOMAIN_NAME:-"localhost"}

mkdir -p /etc/nginx/certs

openssl req -new -newkey rsa:2048 -nodes \
		-keyout /etc/nginx/certs/$DOMAIN_NAME.key \
		-x509 -days 365 -out /etc/nginx/certs/$DOMAIN_NAME.crt \
		-subj "/C=MG/ST=Antananarivo/L=Antananarivo/O=42Antananarivo/CN=$DOMAIN_NAME"

chmod 600 /etc/nginx/certs/$DOMAIN_NAME.key
chmod 644 /etc/nginx/certs/$DOMAIN_NAME.crt

sed -i "s/DOMAIN_NAME/$DOMAIN_NAME/g" /etc/nginx/sites-available/default
