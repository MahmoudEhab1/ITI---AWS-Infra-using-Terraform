variable "public_subnet_ids" {
  description = "A list of public subnet IDs where proxy instances will be launched."
  type        = list(string)
}

variable "proxy_sg_id" {
  description = "The ID of the security group for the proxy instances."
  type        = string
}

variable "proxy_instance_type" {
  description = "The instance type for the Nginx proxy EC2 instances."
  type        = string
}

variable "availability_zones" {
  description = "A list of availability zones."
  type        = list(string)
}

variable "ssh_key_name" {
  description = "Terraform"
  type        = string
}

variable "public_alb_target_group_arn" {
  description = "The ARN of the public ALB target group to register proxies with."
  type        = string
}

variable "internal_alb_dns_name" {
  description = "The DNS name of the internal ALB."
  type        = string
}