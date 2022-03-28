locals {
  # This variable assignment is not mandatory but it helps by making input parameters easier to read.
  # $1 BLUE_ASN 
  p1 = var.blue_asn
  # $2 BLUE_OUTSIDE_IP1 
  p2 = aws_vpn_connection.blue_vpn.tunnel1_address
  # $3 BLUE_OUTSIDE_IP2 
  p3 = aws_vpn_connection.blue_vpn.tunnel2_address
  # $4 BLUE_INSIDE_IP1 
  p4 = aws_vpn_connection.blue_vpn.tunnel1_vgw_inside_address
  # $5 BLUE_INSIDE_IP2  
  p5 = aws_vpn_connection.blue_vpn.tunnel2_vgw_inside_address
  # $6 GREEN_ASN 
  p6 = var.green_asn
  # $7 GREEN_OUTSIDE_IP1 
  p7 = aws_eip.green_vpn_inst.public_ip
  # $8 GREEN_INSIDE_IP1 
  p8 = aws_vpn_connection.blue_vpn.tunnel1_cgw_inside_address
  # $9 GREEN_INSIDE_IP2 
  p9 = aws_vpn_connection.blue_vpn.tunnel2_cgw_inside_address
  # $10 TUNNEL1_PRESHARED_KEY 
  p10 = aws_vpn_connection.blue_vpn.tunnel1_preshared_key
  # $11 TUNNEL2_PRESHARED_KEY 
  p11 = aws_vpn_connection.blue_vpn.tunnel2_preshared_key
  # $12 GREEN_PREFIXES  (DO NOT CHANGE)
  p12 = replace(module.green_vpc.vpc_cidr_block, "/", "BACKSLASH")
# Git repo
  p13 = "bsrodrigs/terraform-aws-fullyconnectedvpn/alpha"
  #p13 = replace(local.git_repo, "/", "BACKSLASH")

  #Auxiliar variables
  #p12 =  replace(tostring(join("", [for p in local.green_prefixes : join("", [local.green_prefixes_config_string, " ", "network ", p, "\n" ]) ])), "/", "BACKSLASH")
  #green_prefixes = concat(module.green_vpc.public_subnets_cidr_blocks, module.green_vpc.private_subnets_cidr_blocks, var.green_additonal_prefixes_advertise)
  #green_prefixes_config_string = "" 
}

