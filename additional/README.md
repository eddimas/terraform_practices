Here's a concise Terraform code snippet to create a static site infrastructure using an S3 bucket and CloudFront:

Remember to replace the following placeholders in the code:

    your_region with the AWS region where you want to create the resources (e.g., "us-east-1").
    your_bucket_name with the desired name for your S3 bucket.
    your_domain.com and www.your_domain.com with your actual domain or subdomain.

This code will create an S3 bucket for hosting the static site files, configure it as a static website, and then create a CloudFront distribution that serves the content from the S3 bucket. The CloudFront distribution is configured to use your provided domain and subdomain aliases.