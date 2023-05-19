output "site_name" {
  value = aws_cloudfront_distribution.static_site_distribution.domain_name
}

output "example_result" {
  value = chatgpt_prompt.example.result
}
