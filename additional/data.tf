provider "aws" {
  profile = "default"
  region  = var.region
}

terraform {
  required_providers {
    chatgpt = {
      version = "0.0.1"
      source  = "develeap/chatgpt"
    }
  }
}

provider "chatgpt" {
  api_key = var.chatgpt_api_key
}

data "aws_route53_zone" "domain_name_zone" {
  name = var.domain_name
}