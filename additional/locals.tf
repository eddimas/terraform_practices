locals {
  validation_options = tolist(aws_acm_certificate.static_site_certificate.domain_validation_options)
}
