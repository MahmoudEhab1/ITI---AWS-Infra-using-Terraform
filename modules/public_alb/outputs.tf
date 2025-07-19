output "public_alb_dns_name" {
  description = "The DNS name of the public ALB."
  value       = aws_lb.public_alb.dns_name
}

output "alb_target_group_arn" {
  description = "The ARN of the public ALB target group."
  value       = aws_lb_target_group.public_alb_tg.arn
}