sudo yum update -y
sudo yum install wget git nano epel-release nfs-utils -y
sudo yum install nginx -y
sudo wget https://raw.githubusercontent.com/Deytron/monrepo/master/tp4/files/nginx.conf -O /etc/nginx/nginx.conf 
sudo nginx

#NFS
mkdir /mnt/nfsfileshare
mount 192.168.56.14:/nfsfileshare /mnt/nfsfileshare

# HOSTS
sudo echo "192.168.56.11  node1.tp4.gitea node1gitea" >> /etc/hosts
sudo echo "192.168.56.12  node2.tp4.bdd node2bdd" >> /etc/hosts
sudo echo "192.168.56.14  node4.tp4.nfs node4nfs" >> /etc/hosts

