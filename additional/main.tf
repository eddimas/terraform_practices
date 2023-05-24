# Create an S3 bucket for the static site
resource "aws_s3_bucket" "static_site_bucket" {
  bucket = var.bucket_name

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
}

# Define the S3 bucket policy
resource "aws_s3_bucket_policy" "static_site_bucket_policy" {
  bucket = aws_s3_bucket.static_site_bucket.id
  policy = data.template_file.bucket_policy.rendered
}


resource "aws_s3_bucket_public_access_block" "static_site_bucket_policy" {
  bucket = aws_s3_bucket.static_site_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Create an ACM certificate for the static site
resource "aws_acm_certificate" "static_site_certificate" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["www.${var.domain_name}"]
}

# Create DNS validation records for the ACM certificate

resource "aws_route53_record" "static_site_certificate_validation" {

  count = length(local.validation_options)

  zone_id = data.aws_route53_zone.domain_name_zone.id
  name    = local.validation_options[count.index].resource_record_name
  type    = local.validation_options[count.index].resource_record_type
  ttl     = 300
  records = [local.validation_options[count.index].resource_record_value]

}

# Create a CloudFront distribution for the static site
resource "aws_cloudfront_distribution" "static_site_distribution" {
  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "S3-${aws_s3_bucket.static_site_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  price_class = "PriceClass_100"

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.static_site_certificate.arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name              = "${aws_s3_bucket.static_site_bucket.bucket}.s3.${aws_s3_bucket.static_site_bucket.region}.amazonaws.com"
    origin_id                = "S3-${aws_s3_bucket.static_site_bucket.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.static_site_origin_access_control.id
  }

  aliases = [var.domain_name, "www.${var.domain_name}"]
}

resource "aws_cloudfront_origin_access_control" "static_site_origin_access_control" {
  name                              = "static_site_origin_access_control"
  description                       = "Restrict access to the static site"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


# Create DNS records for the static site
resource "aws_route53_record" "static_site_dns_record" {
  count   = 2
  zone_id = data.aws_route53_zone.domain_name_zone.id
  name    = count.index == 0 ? var.domain_name : "www.${var.domain_name}"
  type    = "A"
  lifecycle {
    create_before_destroy = true
  }
  alias {
    name                   = aws_cloudfront_distribution.static_site_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.static_site_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

