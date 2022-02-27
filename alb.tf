resource "aws_lb" "alb" {
  name     = "alb"
  internal = false

  security_groups                  = [aws_security_group.lb_sec.id]
  load_balancer_type               = "application"
  subnets                          = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  idle_timeout                     = 400
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.default.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "default" {
  name                 = "targetgroup"
  port                 = 80
  protocol             = "HTTP"
  protocol_version     = "HTTP1"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 300
  target_type          = "instance"
  slow_start           = 0

  load_balancing_algorithm_type = "least_outstanding_requests"

  stickiness {
    enabled = true
    type    = "lb_cookie"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "test" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.default.arn
  target_id        = element(split(",", join(",", aws_instance.wordpress.*.id)), count.index)
  port             = 80
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = aws_lb_listener.main.arn

    action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }

  condition {
    path_pattern {
      values = ["/wp-admin/install.php"]
    }
  }
}