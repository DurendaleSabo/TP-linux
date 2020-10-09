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
