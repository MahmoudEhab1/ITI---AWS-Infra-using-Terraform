output "public_subnet_ids" {
  description = "A list of IDs of the created public subnets."
  value       = [for s in aws_subnet.public : s.id]
}