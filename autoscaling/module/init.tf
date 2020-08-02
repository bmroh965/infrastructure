provider "aws" {
  region = var.aws_region
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
  description = "Max containers count for autoscale."
  default     = 2
}

variable "autoscale_max_capacity" {
  type        = number
  description = "Max containers count for autoscale."
  default     = 4
}
