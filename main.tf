# main.tf
provider "aws" {
  region     = var.region
  access_key = var.access_key # Please address the security risk!
  secret_key = var.secret_key # Please address the security risk!
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "blog" { # Keep the name "blog"
  bucket        = "revbucket-${random_string.random.result}"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "blog" {
  bucket = aws_s3_bucket.blog.id # Corrected reference

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.blog.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}



resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.blog.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PublicReadPolicy"
    Statement = [
      {
        Sid       = "AllowPublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.blog.id}/*" # Use dynamic bucket ID
        ]
      }
    ]
  })
}


resource "aws_s3_object" "upload_object" {
  for_each = fileset("html/", "*")
  bucket   = aws_s3_bucket.blog.id # Reference the correct bucket resource

  key          = each.value
  source       = "html/${each.value}"
  etag         = filemd5("html/${each.value}")
  content_type = "text/html"
}
