# FightPandemics ElastiCache Infrastructure

This repo contains the Terraform code for setting up the FightPandemics ElastiCache infrastructure.

Note that the Terraform state for this module is separate from the main infrastructure Terraform state.

## Prerequisites

1. Install Terraform v0.12.29 by downloading the package for your operating system [here](https://www.terraform.io/downloads.html). Alternatively, you can run Terraform in [Docker](https://hub.docker.com/r/hashicorp/terraform). NOTE: Please install Terraform v0.12.29 as v0.13 has some breaking changes.

1. In the `#devops` Slack channel, ask for the following:
- Access to this repository (provide your Github username)
- Access to our sandbox development AWS account (provide your email address)

## Contributing and Testing in Development environment

1. Clone this repo, and create a new branch.

1. Change directory into the `cache` folder in this repo.

1. Copy `fp_context.cache.env.example` to `development.env`. In the `#devops` Slack channel, ask for the proper values to add to this file for the development environment. Please note that the AWS credentials are session-based, and therefore they are short-lived.

1. Confirm in the `#devops` channel that no one else is currently working in the development AWS account, so that you don't interfere with their work.

1. After confirmation that no one is working in dev environment, run `./deploy.sh plan development`. This will show the proposed changes to be made to the infrastructure. Make sure that proposed changes are what you would expect.

1. Run `./deploy.sh apply development` to apply your changes to the infrastructure.

1. Log in to the development AWS account to verify that the changes look good.

1. Once you have verified that the app is still functional, and also performed any other tests you deem necessary to validate your changes, open a pull request for your changes.

1. To save costs in the development environment, please destroy the resources that you created (ideally within the same day). In the FightPandemics/Infrastructure repo, go to s3cloudfront folder and run `./deploy.sh destroy development` to destroy the development cache infrastructure.
