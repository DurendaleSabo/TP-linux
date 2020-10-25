sudo yum update -y
sudo yum install wget git nano epel-release mariadb-server nfs-utils -y
sudo yum install nginx -y
sudo useradd git
sudo mkdir -p /etc/gitea /var/lib/gitea/{custom,data,indexers,public,log}
sudo chown git:git /var/lib/gitea/{data,indexers,log}
sudo chmod 750 /var/lib/gitea/{data,indexers,log}
sudo chown root:git /etc/gitea
sudo chmod 770 /etc/gitea
echo "bind-address = 192.168.56.12" >> /etc/my.cnf
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo wget https://github.com/go-gitea/gitea/releases/download/v1.12.5/gitea-1.12.5-linux-amd64 -O /usr/local/bin/gitea
sudo chmod +x /usr/local/bin/gitea
sudo wget https://raw.githubusercontent.com/Deytron/monrepo/master/tp4/files/gitea.service -O /etc/systemd/system/gitea.service
sudo systemctl enable gitea
sudo systemctl start gitea

#NFS
mkdir /mnt/nfsfileshare
mount 192.168.56.14:/nfsfileshare /mnt/nfsfileshare

# HOSTS
sudo echo "192.168.56.12  node2.tp4.bdd node2bdd" >> /etc/hosts
sudo echo "192.168.56.13  node3.tp4.nginx node3nginx" >> /etc/hosts
sudo echo "192.168.56.14  node4.tp4.nfs node4nfs" >> /etc/hosts
