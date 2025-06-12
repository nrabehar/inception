#!/bin/bash
set -e

echo "Starting Nginx setup script..."

/tmp/ssl.sh

"$@"
