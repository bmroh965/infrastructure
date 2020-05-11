locals {
  project_id = var.mongo_project_id
}

resource "random_password" "fp_app" {
  length = 16
  special = false
  number = true
}

resource "mongodbatlas_network_container" "container" {
  project_id       = local.project_id
  atlas_cidr_block = "10.8.0.0/21"
  provider_name    = "AWS"
  region_name      = upper(replace(var.aws_region, "-", "_"))
}

resource "mongodbatlas_network_peering" "peer" {
  accepter_region_name   = var.aws_region
  project_id             = local.project_id
  container_id           = mongodbatlas_network_container.container.container_id
  provider_name          = "AWS"
  route_table_cidr_block = module.vpc.vpc_cidr_block
  vpc_id                 = module.vpc.vpc_id
  aws_account_id         = var.aws_account_id
}

# the following assumes an AWS provider is configured
resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = mongodbatlas_network_peering.peer.connection_id
  auto_accept = true
}

# Route tables for peering connection
# TODO figure out how to make this DRY using a loop
resource "aws_route" "peering-owner-az1" {
  route_table_id            = module.vpc.private_route_table_ids[0]
  destination_cidr_block    = "10.8.0.0/21"
  vpc_peering_connection_id = mongodbatlas_network_peering.peer.connection_id
}

resource "aws_route" "peering-owner-az2" {
  route_table_id            = module.vpc.private_route_table_ids[1]
  destination_cidr_block    = "10.8.0.0/21"
  vpc_peering_connection_id = mongodbatlas_network_peering.peer.connection_id
}

resource "aws_route" "peering-owner-az3" {
  route_table_id            = module.vpc.private_route_table_ids[2]
  destination_cidr_block    = "10.8.0.0/21"
  vpc_peering_connection_id = mongodbatlas_network_peering.peer.connection_id
}

resource "mongodbatlas_project_ip_whitelist" "whitelist" {
  project_id = local.project_id
  cidr_block = module.vpc.vpc_cidr_block
  comment    = "Allow all from VPC CIDR Block"
}

resource "mongodbatlas_database_user" "fp_app" {
  username           = "fp_app"
  password           = random_password.fp_app.result
  project_id         = local.project_id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = "fightpandemics"
  }
}
