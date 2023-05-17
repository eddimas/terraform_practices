resource "aws_iam_role" "my_iam_role" {
  name               = "my-iam-role"
  assume_role_policy = file(var.my_iam_role)
}

resource "aws_iam_policy" "autoscaling_policy" {
  name   = "my-autoscaling-policy"
  policy = file(var.my_autoscaling_policy)
}

resource "aws_iam_role_policy_attachment" "autoscaling_policy_attachment" {
  policy_arn = aws_iam_policy.autoscaling_policy.arn
  role       = aws_iam_role.my_iam_role.name
}

resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "my-instance-profile"
  role = aws_iam_role.my_iam_role.name
}

