# A fully connected AWS site-to-site VPN with BGP
This module should be used to test over a fully connected VPN between two VPCs

If you need to test a site-to-site VPN you'll need to a Customer gateway where your IPSec tunnel will end up, in addition to that, if you need to have advertise your prefixes dynamically you'll also need a platform that runs BGP. You can find several platforms in AWS Marketplace that but you may not be familiar with their configuration and you certainly have a learning curve. This module you help those who need a VPN connection up and running for testing purposes.

This module setup all the resources you need to have a site-to-site VPN running and it also configure IPsec tunnel and BGP neighboors for you. 
## Table of contents

### Features
- A fully configured AWS Site-to-site VPN with dynamic routing 
- Can be used as a standalone project or integrated with your own resources  
- Configurable IPSec tunnel
- Dynamic route propagation with BGP 
- 

### Usage
``

### VPN EC2 instance gateway
## Teste


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_blue_vpc"></a> [blue\_vpc](#module\_blue\_vpc) | terraform-aws-modules/vpc/aws | 3.13.0 |
| <a name="module_green_vpc"></a> [green\_vpc](#module\_green\_vpc) | terraform-aws-modules/vpc/aws | 3.13.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.green_vpn_inst](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.green_vpn_inst_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_instance.green_vpn_inst](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.green_vpn_inst](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route.green_blue_side_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group.green_vpn_inst_ipsec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.green_vpn_inst_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.green_vpn_inst](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_vpn_connection.blue_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [tls_private_key.green_vpn_inst](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.vpn_inst_ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_prefixes_advertise"></a> [additional\_prefixes\_advertise](#input\_additional\_prefixes\_advertise) | (Optional) Green subnets are automatically advertised. In addition to those them, you can advertise other sunets by adding their CIDR to this list. | `list(any)` | `[]` | no |
| <a name="input_allowed_networks_ssh"></a> [allowed\_networks\_ssh](#input\_allowed\_networks\_ssh) | (Optional) Allowed IP/networks to ssh VPN instance (green). Eg. single address [1.1.1.1/32] or multple addresses or networks [1.1.1.1/32, 2.2.2.2/32] | `list(any)` | `[]` | no |
| <a name="input_blue_asn"></a> [blue\_asn](#input\_blue\_asn) | (Optional) BGP autonomous system number for blue side | `string` | `"64620"` | no |
| <a name="input_blue_vpc_cidr"></a> [blue\_vpc\_cidr](#input\_blue\_vpc\_cidr) | (Optional) Blue side VPC CIDR (/16 is required). | `string` | `"10.1.0.0/16"` | no |
| <a name="input_green_asn"></a> [green\_asn](#input\_green\_asn) | (Optional) BGP autonomous system number for green side | `string` | `"65220"` | no |
| <a name="input_green_vpc_cidr"></a> [green\_vpc\_cidr](#input\_green\_vpc\_cidr) | (Optional) Green side VPC CIDR (/16 is required). | `string` | `"10.2.0.0/16"` | no |
| <a name="input_green_vpn_endpoint_instancetype"></a> [green\_vpn\_endpoint\_instancetype](#input\_green\_vpn\_endpoint\_instancetype) | (Optional) VPN endpoints are EC2 ubuntu instances that terminates IPSEC tunnel. t3a.micro is suitable for connectivity tests but if you have performance requirements make sure that you select a proper instance type. | `string` | `"t3a.micro"` | no |
| <a name="input_project_label"></a> [project\_label](#input\_project\_label) | The tag value to mark resources from this project (the key is <<project>>) | `string` | `"s2svpn-conn"` | no |
| <a name="input_vpn_endpoint_keyname"></a> [vpn\_endpoint\_keyname](#input\_vpn\_endpoint\_keyname) | (Optional) Specify a key name of the Key Pair to use for the vpn endpoint instance in the green side. If not specified, this module will create a new key. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_blue_vpc"></a> [blue\_vpc](#output\_blue\_vpc) | VPC outputs for blue side. For more details see official documentation from Terraform registry https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest?tab=outputs |
| <a name="output_green_vpc"></a> [green\_vpc](#output\_green\_vpc) | VPC outputs for green side. For more details see official documentation from Terraform registry https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest?tab=outputs |
<!-- END_TF_DOCS -->