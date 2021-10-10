resource "aws_lb_target_group" "example" {
  name                 = "example"
  target               = "ip"
  vpc_id               = aws_vpc.example.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 300

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  dependends_on = [aws_lb.example]
}