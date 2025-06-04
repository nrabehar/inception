-- MariaDB initialization script for Inception project
-- nrabehar@student.42antananarivo.mg

-- Create WordPress database
CREATE DATABASE IF NOT EXISTS wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create WordPress user with secure password
CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppassword123!';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';

-- Create admin user (not using 'admin' username as per requirements)
CREATE USER IF NOT EXISTS 'nrabehar'@'%' IDENTIFIED BY 'nrabehar42secure!';
GRANT ALL PRIVILEGES ON wordpress.* TO 'nrabehar'@'%';

-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootpassword123!';

-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';

-- Remove remote root login
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Remove test database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';

-- Reload privilege tables
FLUSH PRIVILEGES;
