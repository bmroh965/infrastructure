resource "aws_ssm_parameter" "db_host" {
  name = "/fp/database/host"
  type = "String"
  value = var.mongo_host
}

resource "aws_ssm_parameter" "db_user" {
  name = "/fp/database/user"
  type = "String"
  value = "fp_app"
}

resource "aws_ssm_parameter" "db_password" {
  name = "/fp/database/password"
  type = "SecureString"
  value = random_password.fp_app.result
}

resource "aws_ssm_parameter" "domain" {
  name = "/fp/domain"
  type = "String"
  value = var.domain
}
