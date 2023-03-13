resource "aws_s3_bucket" "s3bucket" {

  bucket = var.bucket-name

  tags = merge(var.tags, {
    Module = "Terraform S3 Module"
  })
}


resource "aws_s3_bucket_public_access_block" "s3bucket-public-policy" {
  bucket = aws_s3_bucket.s3bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}