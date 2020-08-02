# Fargate Autoscaling

This module sets up autoscaling for the Fargate service, based on the average CPU utilization of the instances in the Fargate service. This is only used in production. The desired count is nominally 2 instances, and will scale up to 4 instances.

Note that the Terraform state for this module is separate from the main infrastructure Terraform state.

## Deployment

1. Install Terraform, by downloading the package for your operating system [here](https://www.terraform.io/downloads.html). Alternatively, you can run Terraform in [Docker](https://hub.docker.com/r/hashicorp/terraform).
1. Request AWS credentials from a lead DevOps engineer in the `#devops` Slack channel. Add these credentials to a file named `production.env` in this folder.
1. Run `./run-terraform.sh plan` to verify that the changes proposed look good.
1. Run `./run-terraform.sh apply` to apply the changes.
