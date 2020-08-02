#!/bin/bash

# For production only
# Usage:
#   Plan: ./run-terraform.sh plan
#   Apply: ./run-terraform.sh apply

set -e

. production.env

export TF_VAR_fp_context=production
export TF_VAR_aws_region=$AWS_DEFAULT_REGION
export TF_VAR_aws_account_id=$AWS_ACCOUNT_ID

terraform init -reconfigure
terraform $1
