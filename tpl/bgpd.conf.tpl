!
hostname bgpd
password zebra
log stdout
!
router bgp GREEN_ASN
 bgp router-id GREEN_OUTSIDE_IP1
 network GREEN_NETWORKS
 neighbor BLUE_INSIDE_IP1 remote-as BLUE_ASN
 neighbor BLUE_INSIDE_IP2 remote-as BLUE_ASN
!
 address-family ipv6
 exit-address-family
 exit
!
access-list all permit any
!
line vty
!
