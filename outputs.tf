# outputs.tf
output "s3_bucket_website_endpoint" {
  value       = aws_s3_bucket_website_configuration.blog.website_endpoint
  description = "The website endpoint of the S3 bucket"
}