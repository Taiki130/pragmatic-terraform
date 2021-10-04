resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-reponse"

    fixed_response {
      content_type = "text/plain"
      message_body = "ここは『HTTP』です"
      status_code  = "200"
    }
  }
}
