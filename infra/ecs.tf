resource "aws_ecs_cluster" "ecs_application_cluster" {
  name = "${var.fp_context}-cluster"
}
