variable "app_name" {
  type        = string
  description = "Name of Application"
}
variable "environment" {
  type        = string
  description = "Name of Environment"
}
variable "health_check_path" {
  type        = string
  description = "Container URL path for health check"
}
variable "vpc_id" {
  type        = string
  description = "VPC ID where ALB will be deployed"
}

variable "subnets" {
  type        = list(any)
  description = "List of Subnets to use for ALB"
}
