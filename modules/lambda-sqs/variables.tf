variable "queue-name" {
  type        = string
  description = "Name of the queue"
}
variable "function-name" {
  type        = string
  description = "Name of the queue"
}
variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}