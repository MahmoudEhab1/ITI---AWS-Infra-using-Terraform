output "proxy_public_ips" {
  description = "A list of public IP addresses of the Nginx proxy instances."
  value       = [for instance in aws_instance.proxy : instance.public_ip]
}

output "proxy_private_ips" {
  description = "A list of private IP addresses of the Nginx proxy instances."
  value       = [for instance in aws_instance.proxy : instance.private_ip]
}