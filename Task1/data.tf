provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}
