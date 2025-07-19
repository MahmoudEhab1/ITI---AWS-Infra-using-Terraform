variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones."
  type        = list(string)
}

variable "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  type        = string
}