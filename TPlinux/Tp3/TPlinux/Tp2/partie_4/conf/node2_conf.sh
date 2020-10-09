#!/bin/bash

# Buton Killian
# 01/10/2020
#script pour vagrant

# Config /etc/hosts
echo "192.168.2.21 node1.tp2.b2" | tee /etc/hosts

# Trust le certificats
cp /tmp/ssl/server.crt /usr/share/pki/ca-trust-source/anchors/
update-ca-trust

rm -r /tmp/ssl/