output "blue_vpc" {
  value       = module.blue_vpc
  description = "Blue side VPC outputs. For more details see official documentation https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest?tab=outputs"
}

output "green_vpc" {
  value       = module.green_vpc
  description = "Green side VPC outputs. For more details see official documentation https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest?tab=outputs"
}