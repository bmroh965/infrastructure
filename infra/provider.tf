provider "aws" {
  region  = var.aws_region
  version = "~> 2.70.0"
}

provider "mongodbatlas" {
  version = "~> 0.6.3"
}
