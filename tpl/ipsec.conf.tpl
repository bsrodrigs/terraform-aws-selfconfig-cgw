# ipsec.conf - strongSwan IPsec configuration file

# basic configuration

config setup
	# strictcrlpolicy=yes
         uniqueids = no

# Add connections here.

# Connection provided by the AWS config file

conn Tunnel1
	auto=start
	left=%defaultroute
	leftid=GREEN_OUTSIDE_IP1
	right=BLUE_OUTSIDE_IP1
	type=tunnel
	leftauth=psk
	rightauth=psk
	keyexchange=ikev2
	ike=aes128-sha1-modp1024
	ikelifetime=8h
	esp=aes128-sha1-modp1024
	lifetime=1h
	keyingtries=%forever
	leftsubnet=0.0.0.0/0
	rightsubnet=0.0.0.0/0
	dpddelay=10s
	dpdtimeout=30s
	dpdaction=restart
	mark=100
	leftupdown="/etc/ipsec.d/aws-updown.sh -ln Tunnel1 -ll GREEN_INSIDE_IP1/30 -lr BLUE_INSIDE_IP1/30 -m 100"

conn Tunnel2
	auto=start
	left=%defaultroute
	leftid=GREEN_OUTSIDE_IP1
	right=BLUE_OUTSIDE_IP2
	type=tunnel
	leftauth=psk
	rightauth=psk
	keyexchange=ikev2
	ike=aes128-sha1-modp1024
	ikelifetime=8h
	esp=aes128-sha1-modp1024
	lifetime=1h
	keyingtries=%forever
	leftsubnet=0.0.0.0/0
	rightsubnet=0.0.0.0/0
	dpddelay=10s
	dpdtimeout=30s
	dpdaction=restart
	mark=200
	leftupdown="/etc/ipsec.d/aws-updown.sh -ln Tunnel2 -ll GREEN_INSIDE_IP2/30 -lr BLUE_INSIDE_IP2/30 -m 200"