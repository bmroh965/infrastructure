# FightPandemics Infrastructure

This repo contains the Terraform code for setting up the FightPandemics infrastructure.

## Deploy Instructions

1. Install Terraform, by downloading the package for your operating system [here](https://www.terraform.io/downloads.html). Alternatively, you can run Terraform in [Docker](https://hub.docker.com/r/hashicorp/terraform).

2. In the `#devops` Slack channel, ask for the `*.env` file for the environment that you will be deploying to. Save this `*.env` in the root of this repo.

3. Make the necessary changes in the Terraform code.

4. Verify your changes by running `./deploy.sh plan <environment>`, where `<environment>` is the name of the environment that you plan to deploy to (`review`, `staging`, or `production`).

5. Commit and push your changes up, and open a pull request.

6. Once the pull request is approved, run `./deploy.sh apply <environment>`.
