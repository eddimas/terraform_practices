# Target Group

resource "aws_lb_target_group" "my_target_group" {
  name_prefix = "my-tg-"

  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "My Target Group"
  }
}

