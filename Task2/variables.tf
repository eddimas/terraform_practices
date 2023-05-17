variable "my_iam_role" {
  default = "./templates/ec2_role.json"
}

variable "publish_sns_policy" {
  default = "./templates/publish_sns_policy.json"
}