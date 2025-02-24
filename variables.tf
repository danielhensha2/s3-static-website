# variables.tf
variable "region" {
  default     = "us-east-1" # You can keep the default here
  description = "AWS region"
}

variable "access_key" {
  description = "AWS access key (Use with caution! See explanation below)"
  sensitive   = true # Mark as sensitive, but ideally, don't store the actual key here
}

variable "secret_key" {
  description = "AWS secret key (Use with caution! See explanation below)"
  sensitive   = true # Mark as sensitive, but ideally, don't store the actual key here
}