variable "cidr_block" {
  type        = string
  description = "CIDR Block for VPC Creation"
}

variable "public_subnets" {
  type        = list(any)
  description = "Public Subnets to be created"
}

variable "private_subnets" {
  type        = list(any)
  description = "Private Subnets to be created"
}

variable "availability_zones" {
  type        = list(any)
  description = "Availability Zones to be used"
}
variable "environment" {
  type        = string
  description = "Name of Environment"
}