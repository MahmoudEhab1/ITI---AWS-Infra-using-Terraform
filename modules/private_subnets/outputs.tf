output "private_subnet_ids" {
  description = "A list of IDs of the created private subnets."
  value       = [for s in aws_subnet.private : s.id]
}