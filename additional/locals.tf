locals {
  validation_options = tolist(aws_acm_certificate.static_site_certificate.domain_validation_options)
}


locals {
  cloud_front_distributions = aws_cloudfront_distribution.static_site_distribution.id
}
