#!/bin/bash
set -e
FTP_PATH="/var/www/html/ftp"
already_exists=$(ls -A $FTP_PATH 2>/dev/null) || true
if [ "$already_exists" ]; then
		exec "$@"
fi
if [ -z "$FTP_USER" ] || [ -z "$FTP_PASSWORD" ]; then
		echo "Error: FTP user credentials are not set."
		exit 1
fi

# Create FTP user
useradd -m -s /bin/bash $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
# Set permissions
mkdir -p $FTP_PATH
chown -R $FTP_USER:$FTP_USER $FTP_PATH
chmod -R 755 $FTP_PATH
# Create FTP directory
mkdir -p $FTP_PATH/$FTP_USER
chown -R $FTP_USER:$FTP_USER $FTP_PATH/$FTP_USER
chmod -R 755 $FTP_PATH/$FTP_USER
# Create FTP configuration file
FTP_CONFIG="/etc/vsftpd.conf"
echo "listen=YES" > $FTP_CONFIG
echo "anonymous_enable=NO" >> $FTP_CONFIG
echo "local_enable=YES" >> $FTP_CONFIG
echo "write_enable=YES" >> $FTP_CONFIG
echo "local_umask=022" >> $FTP_CONFIG
echo "chroot_local_user=YES" >> $FTP_CONFIG
echo "user_sub_token=\$USER" >> $FTP_CONFIG
echo "local_root=$FTP_PATH/\$USER" >> $FTP_CONFIG
echo "pam_service_name=vsftpd" >> $FTP_CONFIG
echo "secure_chroot_dir=/var/run/vsftpd/empty" >> $FTP_CONFIG
echo "listen_port=21" >> $FTP_CONFIG
echo "ascii_upload_enable=YES" >> $FTP_CONFIG
echo "ascii_download_enable=YES" >> $FTP_CONFIG
echo "ftpd_banner=Welcome to the FTP server" >> $FTP_CONFIG

exec "$@"