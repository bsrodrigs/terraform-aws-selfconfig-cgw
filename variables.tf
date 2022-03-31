variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "(Optional) AWS region where the module will be deployed (eg. eu-west-1)."
  validation {
    condition = can(regex("^(us(-gov)?|ap|ca|cn|eu|sa)-(central|(north|south)?(east|west)?)-[1-9]$", var.region))
    error_message = "Invalid region name (eg. eu-west-1, us-east-1, ...)."
  }
}
variable "green_vpn_inst_keyname" {
  type        = string
  default     = ""
  description = "(Optional) Specify an existing key pair name to associate with the VPN EC2 instance in the green side. This key pair will be used for SSH authentication. If not specified, a new key pair will be created and the private key stored in parameter store."
  validation {
    condition = can(regex("^\\S[[:ascii:]]{1,255}\\S$|^$", var.green_vpn_inst_keyname))
    error_message = "Invalid key pair name (The name can include up to 255 ASCII characters. It cant include leading or trailing spaces.)."
  }
}
variable "project_tags" {
  type        = string
  default     = "https://registry.terraform.io/modules/bsrodrigs/fully-connected-vpn/aws/latest"
  description = "(Optional) A map of convenient tags assigned to all resources."
}

variable "blue_vpc_cidr" {
  type        = string
  default     = "10.1.0.0/16"
  description = "(Optional) Blue side VPC CIDR. VPC size from /16 to /27."
  validation {
    condition = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/(1[6-9]|2[0-7]))?$", var.blue_vpc_cidr))
    error_message = "The VPC CIDR for the blue side is invalid. Make sure the VPC size is from /16 to /27 and CIDR compliant."
  }
}

variable "green_vpc_cidr" {
  type        = string
  default     = "10.2.0.0/16"
  description = "(Optional) Green side VPC CIDR. VPC size from /16 to /27."
  validation {
    condition = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/(1[6-9]|2[0-7]))?$", var.green_vpc_cidr))
    error_message = "The VPC CIDR for the green side is invalid. Make sure the VPC size is from /16 to /27 and CIDR compliant."
  }
}

variable "blue_asn" {
  type        = string
  default     = "64620"
  description = "(Optional) The BGP Autonomous System Number (ASN) for the blue side. Select an ASN from the private pool 64512 - 65534)"
  validation {
    condition = var.blue_asn >= 64512 && var.blue_asn <= 65534
    error_message = "The Autonomous System Number (ASN) defined for the blue side is invalid. Please select any ASN from the private pool (64512-65534)."
  }
}

variable "green_asn" {
  type        = string
  default     = "65220"
  description = "(Optional) The BGP Autonomous System Number (ASN) for the green side. Select an ASN from the private pool 64512 - 65534)"
  validation {
    condition = var.green_asn >= 64512 && var.green_asn <= 65534
    error_message = "The Autonomous System Number (ASN) defined for the green side is invalid. Please select any ASN from the private pool (64512-65534)."
  }
}

variable "green_vpn_endpoint_instancetype" {
  type        = string
  default     = "t3a.micro"
  description = "(Optional) The instance type for the VPN EC2 instance used as Customer Gateway (CGW). Make sure you use an instance type that meets you requirements in network performance."
}

variable "green_vpn_inst_allowed_networks_ssh" {
  type        = list(any)
  default     = []
  description = "(Optional) Allowed networks (CIDR) to SSH to the VPN EC2 instance (green). Eg. 1. Use a single IP [1.1.1.1/32] 2. Use multple IP or networks [1.1.1.1/32, 10.0.1.0/24]"
  validation {
    condition = can([for ip in var.green_vpn_inst_allowed_networks_ssh: regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", ip)])
    error_message = "Invalid List of allowed IP addresses to SSH VPN instance. Make sure the IP's you define are CIDR compliant."
  }
}


variable "green_public_subnet_size" {
  type        = number
  default     = 24
  description = "(Optional) Public subnet size for the green side. This size is a number that defines the subnet mask and can have any value from 16 to 28 as long as it is smaller than VPC size. We recommend to leave the default value If you have limited knowledge in subnetting."
  validation {
    condition = can(regex("^[1][7-9]|[2][0-8]$", var.green_public_subnet_size))
    error_message = "Invalid subnet size. Make sure this subnet size is higher (not equal!) than VPC and its value is in range between 17 to 28."
  }
}


variable "green_private_subnet_size" {
  type        = number
  default     = 24
  description = "(Optional) Private subnet size for the green side. This size is a number that defines the subnet mask and can have any value from 16 to 28 as long as it is smaller than VPC size. We recommend to leave the default value If you have limited knowledge in subnetting."
  validation {
    condition = can(regex("^[1][7-9]|[2][0-8]$", var.green_private_subnet_size))
    error_message = "Invalid subnet size. Make sure this subnet size is higher (not equal!) than VPC and its value is in range between 17 to 28."
  }
}


variable "blue_private_subnet_size" {
  type        = number
  default     = 24
  description = "(Optional) Private subnet size for the blue side. This size is a number that defines the subnet mask and can have any value from 16 to 28 as long as it is smaller than VPC size. We recommend to leave the default value If you have limited knowledge in subnetting."
  validation {
    condition = can(regex("^[1][7-9]|[2][0-8]$", var.blue_private_subnet_size))
    error_message = "Invalid subnet size. Make sure this subnet size is higher (not equal!) than VPC and its value is in range between 17 to 28."
  }
}

variable "blue_public_subnet_size" {
  type        = number
  default     = 24
  description = "(Optional) Public subnet size for the blue side. This size is a number that defines the subnet mask and can have any value from 16 to 28 as long as it is smaller than VPC size. We recommend to leave the default value If you have limited knowledge in subnetting."
  validation {
    condition = can(regex("^[1][7-9]|[2][0-8]$", var.blue_public_subnet_size))
    error_message = "Invalid subnet size. Make sure this subnet size is higher (not equal!) than VPC and its value is in range between 17 to 28."
  }
}