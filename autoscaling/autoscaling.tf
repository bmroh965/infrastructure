terraform {
  backend "s3" {
    bucket = "fp-production-terraform-state"
    region = "eu-west-1"
    key    = "production_autoscaling.tfstate"
  }
}

variable "aws_region" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "fp_context" {
  type = string
}

variable "autoscale_min_capacity" {
  type        = number
  description = "Min containers count for autoscale."
  default     = 2
}

variable "autoscale_max_capacity" {
  type        = number
  description = "Max containers count for autoscale."
  default     = 4
}

module "autoscaling" {
  source                 = "./module"
  aws_region             = var.aws_region
  aws_account_id         = var.aws_account_id
  fp_context             = var.fp_context
  autoscale_max_capacity = var.autoscale_max_capacity
  autoscale_min_capacity = var.autoscale_min_capacity
}
