# TP 3
[Vagrantfile](./Tp3/Vagrantfile)
## I. Services systemd
### 1. Intro
Nombre de services disponibles systemd
```bash
[vagrant@tp3b2 ~]$ systemctl list-unit-files --type=service | tail -1 | cut -d " " -f 1
153
```
Nombre de services actifs systemd
```bash
[vagrant@tp3b2 ~]$ systemctl -t service --all | grep running | wc -l
16
```
Nombre de service failed ou inactif systemd
```bash
[vagrant@tp3b2 ~]$ systemctl -t service --all | grep -E 'inactive|failed' | wc -l
69
```
Nombre de service enabled systemd
```bash
[vagrant@tp3b2 ~]$ systemctl list-unit-files --type=service | grep enabled | wc -l
30
```
### 2. Analyse d'un service
son chemin est /usr/lib/systemd/system/nginx.service comme le montre: 
```bash
[vagrant@tp3 ~]$ systemctl cat nginx.service
# /usr/lib/systemd/system/nginx.service
```
Des commandes sont executer quand se service se lance.e. Pour chaque commandes le premire argument doit être un chemin absolu vers un executable ou un ficher sans slash:
```bash
ExecStart=/usr/sbin/nginx
```
Ses commandes s'execute avant ou après ExecStart:
```bash
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
```
C'est le chemin vers le PID du service:
```bash
PIDFile=/run/nginx.pid
```
Le type du process de démarrage:
```bash
Type=forking
```
La commande pour enclencher un reload de la config du service
```bash
ExecReload=/bin/kill -s HUP $MAINPID
```
description du service:
```bash
Description=The nginx HTTP and reverse proxy server
```

```bash
After=network.target remote-fs.target nss-lookup.target
```
voici la commande qui liste les services qui contiennent WantedBy=multi-user.target:
```bash
[vagrant@tp3b2 ~]$  grep 'WantedBy=multi-user.target' -r . | grep -r "WantedBy=multi-user.target" /run/systemd/transient/
* /etc/systemd/system/* /run/systemd/generator/* /usr/lib/systemd/system/*
grep: /run/systemd/transient/*: No such file or directory
/usr/lib/systemd/system/auditd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/brandbot.path:WantedBy=multi-user.target
/usr/lib/systemd/system/chronyd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/chrony-wait.service:WantedBy=multi-user.target
/usr/lib/systemd/system/cpupower.service:WantedBy=multi-user.target
/usr/lib/systemd/system/crond.service:WantedBy=multi-user.target
/usr/lib/systemd/system/ebtables.service:WantedBy=multi-user.target
/usr/lib/systemd/system/firewalld.service:WantedBy=multi-user.target
/usr/lib/systemd/system/fstrim.timer:WantedBy=multi-user.target
/usr/lib/systemd/system/gssproxy.service:WantedBy=multi-user.target
/usr/lib/systemd/system/irqbalance.service:WantedBy=multi-user.target
/usr/lib/systemd/system/machines.target:WantedBy=multi-user.target
/usr/lib/systemd/system/NetworkManager.service:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs-client.target:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs-rquotad.service:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs-server.service:WantedBy=multi-user.target
/usr/lib/systemd/system/nfs.service:WantedBy=multi-user.target
/usr/lib/systemd/system/postfix.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rdisc.service:WantedBy=multi-user.target
/usr/lib/systemd/system/remote-cryptsetup.target:WantedBy=multi-user.target
/usr/lib/systemd/system/remote-fs.target:WantedBy=multi-user.target
/usr/lib/systemd/system/rhel-configure.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rpcbind.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rpc-rquotad.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rsyncd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/rsyslog.service:WantedBy=multi-user.target
/usr/lib/systemd/system/sshd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/tcsd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/tuned.service:WantedBy=multi-user.target
/usr/lib/systemd/system/vmtoolsd.service:WantedBy=multi-user.target
/usr/lib/systemd/system/wpa_supplicant.service:WantedBy=multi-user.target
```
### 3. Création d'un service
#### a. Serveur web
```bash
[vagrant@tp3b2 system]$ sudo systemctl status configserv.service
● configserv.service - Serveur
   Loaded: loaded (/etc/systemd/system/configserv.service; disabled; vendor preset: disabled)
   Active: active (running) since Wed 2020-10-07 14:36:59 UTC; 4s ago
  Process: 1620 ExecStartPre=/usr/bin/sudo /usr/bin/firewall-cmd --add-port=${PORT}/tcp (code=exited, status=0/SUCCESS)
 Main PID: 1627 (python2)
   CGroup: /system.slice/configserv.service
           └─1627 /usr/bin/python2 -m SimpleHTTPServer 8080

Oct 07 14:36:58 tp3b2 systemd[1]: Starting Serveur...
Oct 07 14:36:58 tp3b2 sudo[1620]:  serveur : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/bin/firewall-cmd --add-port=8080/tcp
Oct 07 14:36:59 tp3b2 systemd[1]: Started Serveur.
``` 
#### b. Sauvegarde
partie scripting prise sur le tp de Gauthier Michon
[Script](./Tp3/scripts_tp)
[Units](./Tp3/systemd/units)
## II. Autres features

### 1. Gestion de boot
```bash
network.service
tuned.service
postfix.service
```
### 2. Gestion de l'heure
```bash
[vagrant@tp3b2 ~]$ timedatectl
      Local time: Wed 2020-10-07 15:50:55 UTC
  Universal time: Wed 2020-10-07 15:50:55 UTC
        RTC time: Wed 2020-10-07 15:50:52
       Time zone: UTC (UTC, +0000)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a
```

```bash
timedatectl list-timezones
```
```bash
 timedatectl set-timezone America/Bogota
```

```bash
[vagrant@tp3b2 ~]$ timedatectl
      Local time: Wed 2020-10-07 10:56:28 -05
  Universal time: Wed 2020-10-07 15:56:28 UTC
        RTC time: Wed 2020-10-07 15:56:25
       Time zone: America/Bogota (-05, -0500)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a
```
### 3. Gestion des noms et de la résolution de noms
```bash
[vagrant@tp3b2 /]$  hostnamectl
   Static hostname: tp3b2
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 109fef3af4d25d4f9cd50ee35f938ec2
           Boot ID: 66b9fdc4987c474eae23b1422b2a895e
    Virtualization: kvm
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-1127.el7.x86_64
      Architecture: x86-64
```
puis je le change a l'aide de ceci:
```bash
[vagrant@tp3b2 /]$ sudo hostnamectl set-hostname michel
```
puis voici le changement: 
```bash
[vagrant@tp3b2 /]$ hostnamectl
   Static hostname: michel
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 109fef3af4d25d4f9cd50ee35f938ec2
           Boot ID: 66b9fdc4987c474eae23b1422b2a895e
    Virtualization: kvm
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-1127.el7.x86_64
      Architecture: x86-64
```



