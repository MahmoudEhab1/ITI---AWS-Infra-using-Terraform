variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1" # Can be changed as per requirement
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "availability_zones" {
  description = "A list of availability zones to deploy resources in."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"] # Adjust based on your region's AZs
}

variable "proxy_instance_type" {
  description = "The instance type for the Nginx proxy EC2 instances."
  type        = string
  default     = "t2.micro"
}

variable "backend_instance_type" {
  description = "The instance type for the backend web server EC2 instances."
  type        = string
  default     = "t2.micro"
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to use for EC2 instances."
  type        = string
  default     = "Terraform" # Replace with your SSH key pair name
}

variable "backend_app_files_path" {
  description = "Local path to the backend application files to be copied to EC2."
  type        = string
  default     = "./backend_app/" # Create this directory and put your app files here
}