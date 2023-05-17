# Path: variables.tf
# Compare this snippet from main.tf:
# sudo systemctl start nginx
# EOF
#

variable "key_pair_name" {
  default = "id-rsa"
}
variable "public_key_path" {
  default = "./static_files/ssh_keys/id-rsa.pub"
}

variable "user_data_script" {
  default = "./static_files/templates/user_data.sh"
}

variable "my_iam_role" {
  default = "./static_files/templates/my_iam_role.json"
}

variable "my_autoscaling_policy" {
  default = "./static_files/templates/my_autoscaling_policy.json"
}

variable "vpc_cidr_block" {
  default = "192.168.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  type    = list(string)
  default = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  type    = list(string)
  default = ["192.168.3.0/24", "192.168.4.0/24"]
}


variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-0889a44b331db0194"
}

variable "autoscaling_group_min_size" {
  default = 2
}

variable "autoscaling_group_max_size" {
  default = 2
}

variable "autoscaling_group_desired_capacity" {
  default = 2
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}