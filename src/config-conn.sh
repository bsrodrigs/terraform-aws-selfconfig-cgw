#!/bin/bash

# Input params
# $1 BLUE_ASN 
# $2 BLUE_OUTSIDE_IP1 
# $3 BLUE_OUTSIDE_IP2 
# $4 BLUE_INSIDE_IP1 
# $5 BLUE_INSIDE_IP2  
# $6 GREEN_ASN 
# $7 GREEN_OUTSIDE_IP1 
# $8 GREEN_INSIDE_IP1 
# $9 GREEN_INSIDE_IP2 
# $10 TUNNEL1_PRESHARED_KEY 
# $11 TUNNEL2_PRESHARED_KEY 
# $12 GREEN_NETWORKS 
# $13 GIT_REPO 

# Local variables
#GIT_REPO='bsrodrigs/terraform-aws-fullyconnectedvpn/alpha'
GIT_REPO=${13}
# Instance Config
sudo hostnamectl set-hostname vpn-endpoint-1
sudo apt update
sudo apt install -y strongswan quagga ntp tcpdump telnet

# StringSwan Config (IPSec)
sudo wget https://raw.githubusercontent.com/$GIT_REPO/tpl/ipsec.conf.tpl -P /etc/ipsec.d/
sudo wget https://raw.githubusercontent.com/$GIT_REPO/src/aws-updown.sh -P /etc/ipsec.d/
sudo wget https://raw.githubusercontent.com/$GIT_REPO/tpl/ipsec.secrets.tpl -P /etc/ipsec.d/ 
sudo chmod +x /etc/ipsec.d/aws-updown.sh
sudo chown ubuntu:ubuntu /etc/ipsec/aws-updown.sh
# Replace params in ipsec.conf
sudo sed -i 's/BLUE_OUTSIDE_IP1/'$2'/g' /etc/ipsec.d/ipsec.conf.tpl
sudo sed -i 's/BLUE_OUTSIDE_IP2/'$3'/g' /etc/ipsec.d/ipsec.conf.tpl
sudo sed -i 's/GREEN_OUTSIDE_IP1/'$7'/g' /etc/ipsec.d/ipsec.conf.tpl
sudo sed -i 's/GREEN_INSIDE_IP1/'$8'/g' /etc/ipsec.d/ipsec.conf.tpl
sudo sed -i 's/GREEN_INSIDE_IP2/'$9'/g' /etc/ipsec.d/ipsec.conf.tpl
sudo sed -i 's/BLUE_INSIDE_IP1/'$4'/g' /etc/ipsec.d/ipsec.conf.tpl
sudo sed -i 's/BLUE_INSIDE_IP2/'$5'/g' /etc/ipsec.d/ipsec.conf.tpl
sudo cp -i /etc/ipsec.d/ipsec.conf.tpl /etc/ipsec.conf.tpl
sudo mv -f /etc/ipsec.conf.tpl /etc/ipsec.conf

# Replace params in ipsec.secrets
sudo sed -i 's/BLUE_OUTSIDE_IP1/'$2'/g' /etc/ipsec.d/ipsec.secrets.tpl
sudo sed -i 's/BLUE_OUTSIDE_IP2/'$3'/g' /etc/ipsec.d/ipsec.secrets.tpl
sudo sed -i 's/GREEN_OUTSIDE_IP1/'$7'/g' /etc/ipsec.d/ipsec.secrets.tpl
sudo sed -i 's/TUNNEL1_PRESHARED_KEY/'${10}'/g' /etc/ipsec.d/ipsec.secrets.tpl
sudo sed -i 's/TUNNEL2_PRESHARED_KEY/'${11}'/g' /etc/ipsec.d/ipsec.secrets.tpl
sudo cp -i /etc/ipsec.d/ipsec.secrets.tpl /etc/ipsec.secrets.tpl
sudo mv -f /etc/ipsec.secrets.tpl /etc/ipsec.secrets

# Quagga Config (BGP)

sudo cp /usr/share/doc/quagga-core/examples/vtysh.conf.sample /etc/quagga/vtysh.conf
sudo cp /usr/share/doc/quagga-core/examples/zebra.conf.sample /etc/quagga/zebra.conf
sudo wget https://raw.githubusercontent.com/$GIT_REPO/tpl/bgpd.conf.tpl -P /etc/quagga/
sudo wget https://raw.githubusercontent.com/$GIT_REPO/src/config-conn.sh -P /home/ubuntu/
sudo chown quagga:quagga /etc/quagga/vtysh.conf
sudo chown quagga:quagga /etc/quagga/zebra.conf
sudo chown quagga:quagga /etc/quagga/bgpd.conf
sudo chmod 0640 /etc/quagga/vtysh.conf
sudo chmod 0640 /etc/quagga/zebra.conf
sudo chmod 0640 /etc/quagga/bgpd.conf

# Replace params in bgpd.conf
sudo sed -i 's/GREEN_ASN/'$6'/g' /etc/quagga/bgpd.conf.tpl
sudo sed -i 's/BLUE_ASN/'$1'/g' /etc/quagga/bgpd.conf.tpl
sudo sed -i 's/BLUE_INSIDE_IP1/'$4'/g' /etc/quagga/bgpd.conf.tpl
sudo sed -i 's/BLUE_INSIDE_IP2/'$5'/g' /etc/quagga/bgpd.conf.tpl
sudo sed -i 's/GREEN_OUTSIDE_IP1/'$7'/g' /etc/quagga/bgpd.conf.tpl
sudo sed -i 's/GREEN_NETWORKS/'"${12}"'/g' /etc/quagga/bgpd.conf.tpl# GREEN_NETWORKS have backslash escaped to avoid sed error
sudo sed -i 's/BACKSLASH/\//g' /etc/quagga/bgpd.conf.tpl # Backslash recovery
sudo cp /etc/quagga/bgpd.conf.tpl /etc/quagga/bgpd.conf

# Start services
sudo ipsec stop
sudo ipsec start
sudo service bgpd start
