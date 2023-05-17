
resource "aws_launch_configuration" "my_launch_config" {
  name_prefix                 = "my-lcfg-"
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  user_data                   = file(var.user_data_script)
  iam_instance_profile        = aws_iam_instance_profile.my_instance_profile.name
  security_groups             = [aws_security_group.my_security_group.id]
  key_name                    = aws_key_pair.my_key_pair.key_name
}

# IAM Instance Profile

resource "aws_iam_instance_profile" "my_instance-profile" {
  role = aws_iam_role.my_iam_role.name
}
