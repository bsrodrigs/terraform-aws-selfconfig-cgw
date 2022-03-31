# KICS - skiped queries 
# - VPC Subnet Assigns Public IP
# - VPC FlowLogs Disabled
# - IAM Access Analyzer Undefined
# - Shield Advanced Not In Use
# - EC2 Instance Using API Keys
# - EC2 Instance Has Public IP
# kics-scan disable=52f04a44-6bfa-4c41-b1d3-4ae99a2de05c,f83121ea-03da-434f-9277-9cd247ab3047,e592a0c5-5bdb-414c-9066-5dba7cdea370,084c6686-2a70-4710-91b1-000393e54c12,0b93729a-d882-4803-bdc3-ac429a21f158,5a2486aa-facf-477d-a5c1-b010789459ce

module "blue_vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "3.13.0"

  name = "blue"
  cidr = var.blue_vpc_cidr

  azs             = [data.aws_availability_zones.available.names[0]]
  public_subnets  = [cidrsubnet(var.blue_vpc_cidr,  var.blue_public_subnet_size - tonumber(split("/", var.blue_vpc_cidr)[1]), 0)]
  private_subnets = [cidrsubnet(var.blue_vpc_cidr,  var.blue_private_subnet_size - tonumber(split("/", var.blue_vpc_cidr)[1]), 1)]

  enable_vpn_gateway = true
  amazon_side_asn    = tostring(var.blue_asn)

  propagate_private_route_tables_vgw = true
  propagate_public_route_tables_vgw  = true

  customer_gateways = {
    IP1 = {
      bgp_asn    = tostring(var.green_asn)
      ip_address = aws_eip.green_vpn_inst.public_ip
    }
  }

  tags = {
    source = var.project_tags
    color   = "blue"
  }

  depends_on = [
    aws_eip.green_vpn_inst
  ]
}

resource "aws_vpn_connection" "blue_vpn" {
  vpn_gateway_id      = module.blue_vpc.vgw_id
  customer_gateway_id = module.blue_vpc.this_customer_gateway.IP1.id
  type                = "ipsec.1"

  tags = {
    source = var.project_tags
    color   = "blue"
  }
}
