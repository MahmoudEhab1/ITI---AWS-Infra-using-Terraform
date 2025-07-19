variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs."
  type        = list(string)
}

variable "alb_sg_id" {
  description = "The ID of the security group for the internal ALB."
  type        = string
}