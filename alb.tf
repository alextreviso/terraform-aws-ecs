resource "aws_lb" "alb" {
  name               = "${var.app_name}-alb"
  internal           = var.private_access
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb.id]
  subnets            = var.private_access ? var.private_subnets_ids : var.public_subnets_ids
 
  enable_deletion_protection = false

  tags = {
    Name        = "${var.app_name}-alb"
    environment = var.env
  }
}
 
resource "aws_alb_target_group" "tg" {
  name        = "${var.app_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
 
  health_check {
   healthy_threshold   = "3"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "3"
   path                = var.healthcheck_url
   unhealthy_threshold = "2"
  }

 depends_on = [aws_lb.alb]

  tags = {
    Name        = "${var.app_name}-tg"
    environment = var.env
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.alb.id
  port              = 80
  protocol          = "HTTP"
 

  default_action {
   type = "redirect"
 
   redirect {
     port        = 443
     protocol    = "HTTPS"
     status_code = "HTTP_301"
   }
  }
}
 
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.alb.id
  port              = 443
  protocol          = "HTTPS"
 
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.crt.arn
 
  default_action {
    target_group_arn = aws_alb_target_group.tg.id
    type             = "forward"
  }
}