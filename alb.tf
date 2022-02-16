resource "aws_elb" "clb" {
  name               = "wordpress"
  availability_zones = var.zones

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/wp-admin/install.php"
    interval            = 30
  }

  instances                   = aws_instance.wordpress.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  security_groups             = [aws_security_group.lb_sec.id]
  connection_draining_timeout = 400

  tags = {
    Name = "Load Balancer for Instances"
  }
}
