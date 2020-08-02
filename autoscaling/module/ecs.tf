data "aws_ecs_cluster" "main" {
  cluster_name = "${var.fp_context}-cluster"
}

data "aws_ecs_service" "app" {
  service_name = var.fp_context
  cluster_arn  = data.aws_ecs_cluster.main.arn
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.autoscale_max_capacity
  min_capacity       = var.autoscale_min_capacity
  resource_id        = "service/${var.fp_context}-cluster/${var.fp_context}"
  role_arn           = "arn:aws:iam::${var.aws_account_id}:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scaling" {
  name = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 50
    scale_in_cooldown  = 10
    scale_out_cooldown = 10
  }
}
