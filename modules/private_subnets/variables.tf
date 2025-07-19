variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones."
  type        = list(string)
}

variable "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  type        = string
}