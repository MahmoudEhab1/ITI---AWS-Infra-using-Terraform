variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs."
  type        = list(string)
}

variable "alb_sg_id" {
  description = "The ID of the security group for the public ALB."
  type        = string
}