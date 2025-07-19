output "internal_alb_dns_name" {
  description = "The DNS name of the internal ALB."
  value       = aws_lb.internal_alb.dns_name
}

output "alb_target_group_arn" {
  description = "The ARN of the internal ALB target group."
  value       = aws_lb_target_group.internal_alb_tg.arn
}