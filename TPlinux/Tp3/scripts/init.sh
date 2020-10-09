#!/bin/sh

yum update -y

yum install vim -y
yum install epel-release -y
yum install nginx -y
yum install tree -y

setenforce 0
echo "SELINUX=permissive\nSELINUXTYPE=targeted" > /etc/selinux/config

systemctl enable firewalld
firewall-cmd --add-port=22/tcp --permanent
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --enable

touch web.service /etc/systemd/system/

touch /usr/local/bin/start.sh
touch /usr/local/bin/stop.sh

chmod 700 /usr/local/bin/start.sh
chmod 700 /usr/local/bin/stop.sh

mkdir /sauvegarde/
mkdir /sauvegarde/site1/
mkdir /srv/
mkdir /srv/site1/
touch /srv/site1/index.html

touch pre_backup.sh
touch backup.sh
touch after_backup.sh

chmod 700 pre_backup.sh
chmod 700 backup.sh
chmod 700 after_backup.sh

touch /etc/systemd/system/backup.service
touch /usr/lib/systemd/system/backup.timer