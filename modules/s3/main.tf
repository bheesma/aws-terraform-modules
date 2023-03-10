resource "aws_s3_bucket" "b" {

  bucket = var.bucket-name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}