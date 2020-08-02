# FightPandemics Infrastructure

This repo contains the Terraform code for setting up the FightPandemics infrastructure.

## Prerequisites

1. Install Terraform, by downloading the package for your operating system [here](https://www.terraform.io/downloads.html). Alternatively, you can run Terraform in [Docker](https://hub.docker.com/r/hashicorp/terraform).

1. Request access to this repository.

1. Request access to our sandbox development AWS account.


## Contributing

1. Clone this repo, and create a new branch.

1. Copy `development.env.example` to `development.env`. In the `#devops` Slack channel, ask for the proper values to add to this file for the development environment. Please note that the AWS credentials are session-based, and therefore they are short-lived. You will need to continually retrieve new credentials after they expire. Please ask in the `#devops` channel for instructions on how to retrieve these credentials.

1. Confirm in the `#devops` channel that no one else is currently working in the development AWS account, so that you don't interfere with their work.

1. Once you have confirmed that no one is working in the development environment, run `./deploy.sh apply development`. This will set up the infrastructure in the development environment.

1. Once the deployment is complete, make the necessary changes in the Terraform code.

1. Validate your Terraform code by running `./deploy.sh validate development`. If there are any syntax errors in the code, it will alert you.

1. Once you have validated and fixed your code, run `./deploy.sh plan development`. This will show you the proposed changes to be made to the infrastructure. Fix any issues if necessary, and also make sure that the changes being proposed are what you would expect.

1. Once you are satisfied with the output of Terraform Plan, run `./deploy.sh apply development`. This will apply your changes to the infrastructure.

1. Log in to the development AWS account to verify that the changes look good.

1. It is strongly recommended that you also deploy the Fargate service and test that the app is still functional with the infrastructure changes you made. Go to the main [FightPandemics](https://github.com/FightPandemics/FightPandemics) repo and clone it if you haven't already.

1. Copy the `development.env` file from this repo to the main FightPandemics repo.

1. Run `./deploy-development.sh apply`.

1. Wait a few minutes for the Fargate service to spin up, and then test the app by going to https://development.fightpandemics.online.

1. Once you have verified that the app is still functional, and also performed any other tests you deem necessary to validate your changes, open a pull request for your changes.

1. To save costs in the development environment, please destroy the resources that you created (ideally within the same day). In the FightPandemics repo, run `./deploy-development.sh destroy` to destroy the Fargate service. After destroying the Fargate service, come back to this repo and run `./deploy.sh destroy development` to destroy the development infrastructure.
