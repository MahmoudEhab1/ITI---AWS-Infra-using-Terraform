output "public_alb_sg_id" {
  description = "The ID of the public ALB security group."
  value       = aws_security_group.public_alb_sg.id
}

output "proxy_sg_id" {
  description = "The ID of the proxy EC2 security group."
  value       = aws_security_group.proxy_sg.id
}

output "internal_alb_sg_id" {
  description = "The ID of the internal ALB security group."
  value       = aws_security_group.internal_alb_sg.id
}

output "backend_sg_id" {
  description = "The ID of the backend EC2 security group."
  value       = aws_security_group.backend_sg.id
}