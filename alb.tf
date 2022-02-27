variable "tg_health_check" {
  type        = map(string)
  default     = {}
  description = "The default target group's health check configuration, will be merged over the default (see locals.tf)"
}

locals {
  tg_default_health_check = {
    "interval"            = 30
    "path"                = "/wp-admin/install.php"
    "healthy_threshold"   = 3
    "unhealthy_threshold" = 3
    "timeout"             = 5
    "protocol"            = "HTTP"
    "matcher"             = "200"
  }

  tg_health_check = merge(local.tg_default_health_check, var.tg_health_check)
}

variable "tg_stickiness" {
  type = map(string)

  default = {
    "type"            = "lb_cookie"
    "cookie_duration" = 1
    "enabled"         = true
  }
}

variable "listener_rules" {
  type        = map
  default     = {}
  description = "A map of listener rules for the LB: priority --> {target_group_arn:'', conditions:[]}. 'target_group_arn:null' means the built-in target group"
}

resource "aws_lb" "alb" {
  name     = "alb"
  internal = false

  security_groups = [aws_security_group.lb_sec.id]

  subnets         = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  idle_timeout    = 400
  ip_address_type = "ipv4"

}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  #ssl_policy        = var.listener_ssl_policy
  #certificate_arn   = var.listener_certificate_arn

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

  dynamic "health_check" {
    for_each = [local.tg_health_check]
    content {
      enabled             = lookup(health_check.value, "enabled", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      interval            = lookup(health_check.value, "interval", null)
      matcher             = lookup(health_check.value, "matcher", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      protocol            = lookup(health_check.value, "protocol", null)
      timeout             = lookup(health_check.value, "timeout", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
    }
  }

  dynamic "stickiness" {
    for_each = [var.tg_stickiness]
    content {
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
      enabled         = lookup(stickiness.value, "enabled", null)
      type            = stickiness.value.type
    }
  }
}

resource "aws_lb_target_group_attachment" "test" {
  count = var.instance_count
  target_group_arn = aws_lb_target_group.default.arn
  target_id        = element(split(",", join(",", aws_instance.wordpress.*.id)), count.index)
  port             = 80
}

resource "aws_lb_listener_rule" "main" {
  for_each     = var.listener_rules
  listener_arn = aws_lb_listener.main.arn

  priority = each.key

  action {
    type             = "forward"
    target_group_arn = each.value["target_group_arn"]
  }

  dynamic "condition" {
    for_each = each.value["conditions"]
    content {
      dynamic "host_header" {
        for_each = condition.value.field == "host-header" ? [condition.value.field] : []
        content {
          values = condition.value.values
        }
      }
      dynamic "path_pattern" {
        for_each = condition.value.field == "path-pattern" ? [condition.value.field] : []
        content {
          values = condition.value.values
        }
      }
      dynamic "source_ip" {
        for_each = condition.value.field == "source-ip" ? [condition.value.field] : []
        content {
          values = condition.value.values
        }
      }
    }
  }
}