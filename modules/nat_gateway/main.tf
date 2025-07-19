resource "aws_eip" "nat" {
  depends_on = [var.public_subnet_id] # Ensure subnet is created before EIP

  tags = {
    Name = "NATGatewayEIP"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id
  depends_on    = [aws_eip.nat]

  tags = {
    Name = "MyNATGateway"
  }
}