variable "environment" {
  type        = string
  description = "Name of Environment"
}
variable "execution_role_name" {
  type        = string
  description = "Name of ECS Task Execution Role"
}
variable "task_role_name" {
  type        = string
  description = "Name of ECS Task Role"
}