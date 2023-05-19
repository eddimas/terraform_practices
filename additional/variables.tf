variable "region" {
  description = "The region to deploy to"
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  default     = "mycloudbuddy-rocks-static-site"
}

variable "domain_name" {
  description = "The domain name to use for the static site"
  default     = "mycloudbuddy.rocks"
}

variable "bucket_policy" {
  description = "The bucket policy to use for the static site"
  default     = "./templates/bucket_policy.json"
}

variable "chatgpt_api_key" {
  description = "The ChatGPT API key to use for the static site"
  type        = string
}