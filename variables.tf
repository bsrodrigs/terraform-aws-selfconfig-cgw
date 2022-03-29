variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region (eg. eu-west-1)"
}
variable "green_vpn_inst_keyname" {
  type        = string
  default     = ""
  description = "(Optional) Specify a key name of the Key Pair to use for the vpn endpoint instance in the green side. If not specified, this module will create a new key."
}
variable "project_label" {
  type        = string
  default     = "s2svpn-conn"
  description = "The tag value to mark resources from this project (the key is <<project>>)"
}

variable "blue_vpc_cidr" {
  type        = string
  default     = "10.1.0.0/16"
  description = "(Optional) Blue side VPC CIDR (/16 is required)."
}

variable "green_vpc_cidr" {
  type        = string
  default     = "10.2.0.0/16"
  description = "(Optional) Green side VPC CIDR (/16 is required)."
}

variable "blue_asn" {
  type        = string
  default     = "64620"
  description = "(Optional) BGP autonomous system number for blue side"
}

variable "green_asn" {
  type        = string
  default     = "65220"
  description = "(Optional) BGP autonomous system number for green side"
}

variable "green_vpn_endpoint_instancetype" {
  type        = string
  default     = "t3a.micro"
  description = "(Optional) VPN endpoints are EC2 ubuntu instances that terminates IPSEC tunnel. t3a.micro is suitable for connectivity tests but if you have performance requirements make sure that you select a proper instance type."
}

variable "green_vpn_inst_allowed_networks_ssh" {
  type        = list(any)
  default     = []
  description = "(Optional) Allowed IP/networks to ssh VPN instance (green). Eg. single address [1.1.1.1/32] or multple addresses or networks [1.1.1.1/32, 2.2.2.2/32]"
}

