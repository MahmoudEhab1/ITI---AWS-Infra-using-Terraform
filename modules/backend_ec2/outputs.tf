output "backend_private_ips" {
  description = "A list of private IP addresses of the backend web server instances."
  value       = [for instance in aws_instance.backend_ws : instance.private_ip]
}