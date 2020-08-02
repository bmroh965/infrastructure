resource "aws_alb" "alb_ext" {
  name            = "${var.fp_context}-alb"
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.web_all_public.id]

}

resource "aws_alb_listener" "alb_ext_http" {
  load_balancer_arn = aws_alb.alb_ext.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "alb_ext_https" {
  load_balancer_arn = aws_alb.alb_ext.arn
  port              = 443
  certificate_arn   = aws_acm_certificate.acm_certificate.arn
  protocol          = "HTTPS"
  default_action {
    fixed_response {
      content_type = "text/plain"
      message_body = "fight pandemics - welcome!\n404 Page Not Found"
      status_code = "404"
    }
    type             = "fixed-response"
  }
}
