#! /usr/bin/env bash

USAGE="
Usage:
  PLAN:  ./deploy.sh plan <fp_context> <domain>
  APPLY: ./deploy.sh apply <fp_context> <domain>
"

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
  echo "$USAGE"
  exit 1
fi

action=$1
fp_context=$2
domain=$3

. $fp_context.env

export TF_VAR_fp_context=$fp_context
export TF_VAR_domain=$domain
export TF_VAR_mongo_project_id=$MONGODB_ATLAS_PROJECT_ID
export TF_VAR_aws_account_id=$AWS_ACCOUNT_ID
export TF_VAR_mongo_host=$MONGODB_HOST
export TF_VAR_aws_region=$AWS_DEFAULT_REGION

cat << EOF > backend.tf
terraform {
  backend "s3" {
    region = "${AWS_DEFAULT_REGION}"
    bucket = "fp-${fp_context}-terraform-state"
    key    = "infrastructure.tfstate"
  }
}
EOF

terraform init

if [[ "$action" == "plan" ]]; then
  terraform validate
  terraform plan
elif [[ "$action" == "apply" ]]; then
  terraform apply -auto-approve
else
  echo "Invalid action $action"
fi
