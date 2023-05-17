# Auto Scaling Group

resource "aws_autoscaling_group" "my_autoscaling_group" {
  name                 = "my-autoscaling-group"
  launch_configuration = aws_launch_configuration.my_launch_config.name
  vpc_zone_identifier  = aws_subnet.public_subnet.*.id
  min_size             = var.autoscaling_group_min_size
  max_size             = var.autoscaling_group_max_size
  desired_capacity     = var.autoscaling_group_desired_capacity
  target_group_arns    = [aws_lb_target_group.my_target_group.arn]
}