variable "cluster_name" {
  type        = string
  description = "Name of the ECS Cluster being created"
}
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}
variable "ecs_task_execution_role" {
  type        = string
  description = "ARN of ECS Task Execution role"
}
variable "ecs_task_role" {
  type        = string
  description = "ARN of ECS Task role"
}
variable "app_name" {
  type        = string
  description = "Name of Application"
}
variable "environment" {
  type        = string
  description = "Name of Environment"
}
variable "container_image" {
  type        = string
  description = "URL for Docker Image"
}
variable "container_port" {
  type        = string
  description = "Port on the container to associate with the load balancer"
}
variable "aws_alb_target_group_arn" {
  type        = string
  description = "ARN of ALB Target group"
}
variable "subnets" {
  type        = list(any)
  description = "List of Subnets to use for ECS"
}
