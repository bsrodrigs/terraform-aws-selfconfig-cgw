output "blue_vpc" {
  value       = module.blue_vpc
  description = "VPC outputs for blue side. For more details see official documentation from Terraform registry https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest?tab=outputs"
}

output "green_vpc" {
  value       = module.green_vpc
  description = "VPC outputs for green side. For more details see official documentation from Terraform registry https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest?tab=outputs"
}