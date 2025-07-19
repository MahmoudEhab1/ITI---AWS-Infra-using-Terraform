terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket-unique-id21" # Replace with your S3 bucket name
    key            = "dev/terraform.tfstate"
    region         = "us-east-1" # Replace with your desired region
    encrypt        = true
    dynamodb_table = "terraform-locks" # Optional: For state locking, create this DynamoDB table
  }
}

provider "aws" {
  region = var.aws_region
}

# --- VPC Module ---
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
}

# --- Public Subnets Module ---
module "public_subnets" {
  source = "./modules/public_subnets"

  vpc_id                = module.vpc.vpc_id
  public_subnet_cidrs   = var.public_subnet_cidrs
  availability_zones    = var.availability_zones
  internet_gateway_id   = module.internet_gateway.internet_gateway_id
}

# --- Private Subnets Module ---
module "private_subnets" {
  source = "./modules/private_subnets"
  vpc_id                 = module.vpc.vpc_id
  private_subnet_cidrs   = var.private_subnet_cidrs
  availability_zones     = var.availability_zones
  nat_gateway_id         = module.nat_gateway.nat_gateway_id
}

# --- Internet Gateway Module ---
module "internet_gateway" {
  source = "./modules/internet_gateway"

  vpc_id = module.vpc.vpc_id
}

# --- NAT Gateway Module ---
module "nat_gateway" {
  source = "./modules/nat_gateway"

  public_subnet_id = module.public_subnets.public_subnet_ids[0] # Associate with the first public subnet
}

# --- Security Groups Module ---
module "security_groups" {
  source = "./modules/security_groups"

  vpc_id = module.vpc.vpc_id
}

# --- Public ALB Module ---
module "public_alb" {
  source = "./modules/public_alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.public_subnets.public_subnet_ids
  alb_sg_id         = module.security_groups.public_alb_sg_id
}

# --- Internal ALB Module ---
module "internal_alb" {
  source = "./modules/internal_alb"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.private_subnets.private_subnet_ids
  alb_sg_id          = module.security_groups.internal_alb_sg_id
}

# --- Proxy EC2 Module ---
module "proxy_ec2" {
  source = "./modules/proxy_ec2"

  public_subnet_ids            = module.public_subnets.public_subnet_ids
  proxy_sg_id                  = module.security_groups.proxy_sg_id
  proxy_instance_type          = var.proxy_instance_type
  availability_zones           = var.availability_zones
  public_alb_target_group_arn  = module.public_alb.alb_target_group_arn
  ssh_key_name                 = var.ssh_key_name
  internal_alb_dns_name        = module.internal_alb.internal_alb_dns_name
}

# --- Backend EC2 Module ---
module "backend_ec2" {
  source = "./backend_ec2"

  private_subnet_ids           = module.private_subnets.private_subnet_ids
  backend_sg_id                = module.security_groups.backend_sg_id
  backend_instance_type        = var.backend_instance_type
  availability_zones           = var.availability_zones
  ssh_key_name                 = var.ssh_key_name
  backend_app_files_path       = var.backend_app_files_path
  internal_alb_target_group_arn = module.internal_alb.alb_target_group_arn
  proxy_public_ips             = module.proxy_ec2.proxy_public_ips
  internal_alb_dns_name        = module.internal_alb.internal_alb_dns_name # <--- ADD THIS LINE
}

# --- Local-exec to print IPs ---
resource "null_resource" "print_ips" {
  depends_on = [
    module.proxy_ec2,
    module.backend_ec2
  ]

  provisioner "local-exec" {
    command = <<-EOT
      echo "public-ip1 ${module.proxy_ec2.proxy_public_ips[0]}" > all-ips.txt
      echo "public-ip2 ${module.proxy_ec2.proxy_public_ips[1]}" >> all-ips.txt
      echo "private-ip1 ${module.backend_ec2.backend_private_ips[0]}" >> all-ips.txt
      echo "private-ip2 ${module.backend_ec2.backend_private_ips[1]}" >> all-ips.txt
    EOT
  }
}