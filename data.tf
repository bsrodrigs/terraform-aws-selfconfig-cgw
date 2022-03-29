
# Retrive Ubuntu 20.04 LTS ami id from any region
data "aws_ami" "green_vpn_inst_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Retirve availability zones from specified region
data "aws_availability_zones" "available" {
  state = "available"
}