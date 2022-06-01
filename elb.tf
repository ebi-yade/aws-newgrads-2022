resource "aws_lb_target_group" "main" {
  name             = "target-${local.name}"
  target_type      = "instance"
  vpc_id           = aws_vpc.main.id
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  port             = 80

  health_check {
    protocol = "HTTP"
    path     = "/wp-includes/images/blank.gif"
  }
}

resource "aws_lb_target_group_attachment" "instance_first" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.first.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance_second" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.second.id
  port             = 80
}

resource "aws_lb" "main" {
  name               = "elb-${local.name}"
  internal           = false
  load_balancer_type = "application"

  ip_address_type            = "ipv4"
  enable_deletion_protection = false

  subnets = [
    aws_subnet.public_az_a.id,
    aws_subnet.public_az_c.id,
  ]

  security_groups = [aws_security_group.web.id]
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
