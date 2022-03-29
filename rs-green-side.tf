# KICS - skiped queries - https://docs.kics.io/latest/queries/all-queries/
# - VPC Subnet Assigns Public IP
# - VPC FlowLogs Disabled
# - IAM Access Analyzer Undefined
# - Shield Advanced Not In Use
# - EC2 Instance Using API Keys
# - EC2 Instance Has Public IP
# - Security Group Not Used
# kics-scan disable=52f04a44-6bfa-4c41-b1d3-4ae99a2de05c,f83121ea-03da-434f-9277-9cd247ab3047,e592a0c5-5bdb-414c-9066-5dba7cdea370,084c6686-2a70-4710-91b1-000393e54c12,0b93729a-d882-4803-bdc3-ac429a21f158,5a2486aa-facf-477d-a5c1-b010789459ce,4849211b-ac39-479e-ae78-5694d506cb24
module "green_vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "3.13.0"

  name = "green"
  cidr = var.green_vpc_cidr

  azs             = [data.aws_availability_zones.available.names[0]]
  private_subnets = [cidrsubnet(var.green_vpc_cidr, 8, 1)]
  public_subnets  = [cidrsubnet(var.green_vpc_cidr, 8, 2)]

  # VPC Flow Logs
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  vpc_flow_log_tags = {
    Name = "vpc-flow-logs-cloudwatch-logs-default"
  }

  tags = {
    project = var.project_label
    color   = "green"
  }
}

# EIP's must be allocated before site-to-site vpn, as these IP's are assigned to the Customer Gateway (CGW)

resource "aws_eip" "green_vpn_inst" {
  vpc = true

  tags = {
    project = var.project_label
    color   = "green"
  }
}


# The association can only occur after 

resource "aws_eip_association" "green_vpn_inst_eip" {
  instance_id   = aws_instance.green_vpn_inst.id
  allocation_id = aws_eip.green_vpn_inst.id
}



resource "aws_route" "green_blue_side_route" {
  route_table_id         = module.green_vpc.public_route_table_ids[0]
  destination_cidr_block = module.blue_vpc.vpc_cidr_block
  network_interface_id   = aws_instance.green_vpn_inst.primary_network_interface_id
  #depends_on                = [aws_route_table.testing]
}


resource "aws_instance" "green_vpn_inst" {

  #checkov:skip=CKV_AWS_79:Instance endpoint cannot be disabled for ssh to work properly

  ami                       = data.aws_ami.green_vpn_inst_ubuntu.id
  instance_type             = var.green_vpn_endpoint_instancetype
  vpc_security_group_ids    = length(var.allowed_networks_ssh) > 0 ? [aws_security_group.green_vpn_inst_ipsec.id, aws_security_group.green_vpn_inst_green_traffic.id, aws_security_group.green_vpn_inst_ssh.id] : [aws_security_group.green_vpn_inst_ipsec.id, aws_security_group.green_vpn_inst_green_traffic.id ]
  subnet_id                 = module.green_vpc.public_subnets[0]
  key_name                  = var.green_vpn_inst_keyname  == "" ? aws_key_pair.green_vpn_inst[0].key_name : var.green_vpn_inst_keyname
  source_dest_check         = "false"
  monitoring                  = true
  ebs_optimized               = true

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  user_data = <<EOF
#!/bin/bash
wget https://raw.githubusercontent.com/${local.p13}/src/config-conn.sh -P /home/ubuntu/
chown ubuntu /home/ubuntu/config-conn.sh 
chmod +x /home/ubuntu/config-conn.sh 
/home/ubuntu/config-conn.sh ${local.p1} ${local.p2} ${local.p3} ${local.p4} ${local.p5} ${local.p6} ${local.p7} ${local.p8} ${local.p9} ${local.p10} ${local.p11} "${local.p12}" "${local.p13}"
EOF


  tags = {
    Name    = "vpn-instance-1"
    project = var.project_label
    color   = "green"
  }
}

resource "aws_security_group" "green_vpn_inst_ipsec" {
  name        = "vpn_inst_ipsec"
  description = "Allow IPSec traffic from Site-to-site VPN"
  vpc_id      = module.green_vpc.vpc_id
  ingress {
    description = "Allow ipsec from AWS Site-to-site VPN"
    from_port   = 1500
    to_port     = 1500
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpn_connection.blue_vpn.tunnel1_address}/32"]
  }
  ingress {
    description = "Allow ipsec from AWS Site-to-site VPN"
    from_port   = 500
    to_port     = 500
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpn_connection.blue_vpn.tunnel1_address}/32"]
  }
  ingress {
    description = "Allow ipsec from AWS Site-to-site VPN"
    from_port   = 1500
    to_port     = 1500
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpn_connection.blue_vpn.tunnel2_address}/32"]
  }
  ingress {
    description = "Allow ipsec from AWS Site-to-site VPN"
    from_port   = 500
    to_port     = 500
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpn_connection.blue_vpn.tunnel2_address}/32"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "vpn_endpoint"
    project = var.project_label
    color   = "green"
  }
}


resource "aws_security_group" "green_vpn_inst_ssh" {
  name        = "vpn_inst_ssh"
  description = "Allow SSH from specified networks for management"
  vpc_id      = module.green_vpc.vpc_id
  ingress {
    description = "Allow SSH from specified networks for management"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.green_vpn_inst_allowed_networks_ssh
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "vpn_endpoint"
    project = var.project_label
    color   = "green"
  }
}


resource "aws_security_group" "green_vpn_inst_green_traffic" {
  name        = "vpn_inst_greentraffic"
  description = "Allow GREEN VPC Traffic to cross VPN instance"
  vpc_id      = module.green_vpc.vpc_id
  ingress {
    description = "Allow SSH from specified networks for management"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.green_vpc.vpc_cidr_block]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "vpn_endpoint"
    project = var.project_label
    color   = "green"
  }
}
# Generate a SSH key pair
resource "tls_private_key" "green_vpn_inst" {
  count     = var.green_vpn_inst_keyname == "" ? 1 : 0
  algorithm = "RSA"
}

resource "aws_key_pair" "green_vpn_inst" {
  count      = var.green_vpn_inst_keyname == "" ? 1 : 0
  key_name   = "vpn-inst-key"
  public_key = tls_private_key.green_vpn_inst[0].public_key_openssh

  tags = {
    project = var.project_label
    color   = "green"
  }
}

resource "aws_ssm_parameter" "green_vpn_inst" {
  count = var.green_vpn_inst_keyname == "" ? 1 : 0
  name  = "vpn_endpoint_private_key"
  type  = "SecureString"
  value = tls_private_key.green_vpn_inst[0].private_key_pem

  tags = {
    project = var.project_label
    color   = "green"
  }
}
