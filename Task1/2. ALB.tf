# Load Balancer

resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subnet.*.id
  security_groups    = [aws_security_group.my_security_group.id]

  tags = {
    Name = "My Load Balancer"
  }
}

# Load Balancer Listener

resource "aws_lb_listener" "my_lb_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    type             = "forward"
  }
}
