output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.public_subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.private_subnets.private_subnet_ids
}

output "public_alb_dns_name" {
  description = "The DNS name of the public Application Load Balancer."
  value       = module.public_alb.public_alb_dns_name
}

output "internal_alb_dns_name" {
  description = "The DNS name of the internal Application Load Balancer."
  value       = module.internal_alb.internal_alb_dns_name
}

output "proxy_public_ips" {
  description = "Public IP addresses of the Nginx proxy instances."
  value       = module.proxy_ec2.proxy_public_ips
}

output "proxy_private_ips" {
  description = "Private IP addresses of the Nginx proxy instances."
  value       = module.proxy_ec2.proxy_private_ips
}

output "backend_private_ips" {
  description = "Private IP addresses of the backend web server instances."
  value       = module.backend_ec2.backend_private_ips
}

# You don't typically need to output instance_ids directly unless specifically required.
# The IPs are usually more useful for debugging/access.