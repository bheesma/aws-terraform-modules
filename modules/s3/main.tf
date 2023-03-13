resource "aws_s3_bucket" "b" {

  bucket = var.bucket-name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  block_public_acls   = true
  ignore_public_acls  = true
  block_public_policy = true
  restrict_public_buckets = true
}