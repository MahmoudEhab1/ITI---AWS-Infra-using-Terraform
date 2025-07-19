variable "private_subnet_ids" {
  description = "A list of private subnet IDs where backend instances will be launched."
  type        = list(string)
}

variable "backend_sg_id" {
  description = "The ID of the security group for the backend instances."
  type        = string
}

variable "backend_instance_type" {
  description = "The instance type for the backend web server EC2 instances."
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

variable "backend_app_files_path" {
  description = "Local path to the backend application files to be copied to EC2."
  type        = string
}

variable "internal_alb_target_group_arn" {
  description = "The ARN of the internal ALB target group to register backend servers with."
  type        = string
}
variable "proxy_public_ips" { # NEW VARIABLE
  description = "Public IP addresses of the Nginx proxy instances to use as jump hosts."
  type        = list(string)
}
variable "internal_alb_dns_name" {
  description = "The DNS name of the internal ALB for backend instances to connect to (e.g., for health checks)."
  type        = string
}