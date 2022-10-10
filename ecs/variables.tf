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
  type        = number
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
variable "task_memory" {
  type        = number
  description = "Memory of Taks/Container in MiB"
}
variable "task_cpu" {
  type        = number
  description = "Numbr of CPU units"
}
variable "desired_count" {
  type        = number
  description = "Numbr of tasks in a service"
}