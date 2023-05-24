output "site_name" {
  value = aws_cloudfront_distribution.static_site_distribution.aliases
}

output "aws_cloudfront_distribution" {
  value = aws_cloudfront_distribution.static_site_distribution.id
}
