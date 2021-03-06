#! /usr/bin/env bash

USAGE="
Usage:
  PLAN:  ./deploy.sh plan <fp_context>
  APPLY: ./deploy.sh apply <fp_context>
  DESTROY: ./deploy.sh destroy <fp_context>
  VALIDATE: ./deploy.sh validate <fp_context>
"

if [[ -z "$1" || -z "$2" ]]; then
  echo "$USAGE"
  exit 1
fi

action=$1
fp_context=$2

if [[ "$action" != "plan" && "$action" != "apply" && "$action" != "destroy" && "$action" != "validate" ]]; then
  echo "$USAGE"
  exit 1
fi

if [[ ! -f $fp_context.env ]]; then
  echo "Cannot find $fp_context.env file."
  exit 1
fi

. $fp_context.env

export TF_VAR_fp_context=$fp_context
export TF_VAR_domain=$DOMAIN
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

  required_version = "~> 0.12.29"
}
EOF

terraform init -reconfigure
terraform $1
