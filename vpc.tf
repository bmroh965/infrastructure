module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.fp_context
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets    = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  create_database_subnet_group = true
  create_database_subnet_route_table = true
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_nat_gateway = true
  enable_vpn_gateway = true
  create_database_internet_gateway_route = true
  public_subnet_tags = {
    Tier = "public"
  }
  private_subnet_tags = {
    Tier = "private"
  }
}
