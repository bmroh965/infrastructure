resource "aws_ssm_parameter" "domain" {
  name = "/fp/domain"
  type = "String"
  value = var.domain
}
