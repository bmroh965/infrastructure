locals {
  project_id       = var.mongo_project_id
  atlas_cidr_block = "10.8.0.0/21"
}

resource "random_password" "fp_app" {
  length  = 16
  special = false
  number  = true
}

resource "mongodbatlas_cluster" "cluster" {
  count      = var.fp_context == "production" ? 1 : 0
  project_id = local.project_id
  name       = "fp-production"
  num_shards = 1

  replication_factor           = 3
  provider_backup_enabled      = true
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "4.2"

  provider_name               = "AWS"
  disk_size_gb                = 40
  provider_disk_iops          = 120
  provider_volume_type        = "STANDARD"
  provider_encrypt_ebs_volume = true
  provider_instance_size_name = "M30"
  provider_region_name        = upper(replace(var.aws_region, "-", "_"))
}

resource "mongodbatlas_network_container" "container" {
  project_id       = local.project_id
  atlas_cidr_block = local.atlas_cidr_block
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
  auto_accept               = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

# Route tables for peering connection
# TODO figure out how to make this DRY using a loop
resource "aws_route" "peering-owner-az1" {
  route_table_id            = module.vpc.private_route_table_ids[0]
  destination_cidr_block    = local.atlas_cidr_block
  vpc_peering_connection_id = mongodbatlas_network_peering.peer.connection_id
}

resource "aws_route" "peering-owner-az2" {
  route_table_id            = module.vpc.private_route_table_ids[1]
  destination_cidr_block    = local.atlas_cidr_block
  vpc_peering_connection_id = mongodbatlas_network_peering.peer.connection_id
}

resource "aws_route" "peering-owner-az3" {
  route_table_id            = module.vpc.private_route_table_ids[2]
  destination_cidr_block    = local.atlas_cidr_block
  vpc_peering_connection_id = mongodbatlas_network_peering.peer.connection_id
}

resource "aws_network_acl" "from_mongo_atlas" {
  vpc_id = module.vpc.vpc_id
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = local.atlas_cidr_block
    from_port  = 443
    to_port    = 443
  }
}

resource "aws_network_acl" "to_mongo_atlas" {
  vpc_id = module.vpc.vpc_id
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = local.atlas_cidr_block
    from_port  = 27015
    to_port    = 27017
  }
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
