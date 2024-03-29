variable "bucket-name" {
  type        = string
  description = "Name of S3 bucket"
}
variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}
variable "environment" {
  type        = string
  description = "Name of the environment"
}