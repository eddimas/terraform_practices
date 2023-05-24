provider "aws" {
  profile = "default"
  region  = var.region
}

data "aws_route53_zone" "domain_name_zone" {
  name = var.domain_name
}

data "aws_caller_identity" "current" {}

data "template_file" "bucket_policy" {
  template = file(var.bucket_policy)

  vars = {
    bucket_name                = var.bucket_name
    aws_account                = data.aws_caller_identity.current.account_id
    cloudfront_distribution_id = aws_cloudfront_distribution.static_site_distribution.id
  }
}
