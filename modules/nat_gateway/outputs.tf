output "nat_gateway_id" {
  description = "The ID of the created NAT Gateway."
  value       = aws_nat_gateway.main.id
}