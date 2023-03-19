variable "queue_name" {
  type        = string
  description = "Name of the queue"
}
variable "function_name" {
  type        = string
  description = "Name of the queue"
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