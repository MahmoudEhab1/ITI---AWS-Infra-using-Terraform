# modules/proxy_ec2/main.tf

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Amazon Linux 2 AMI
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "proxy" {
  count                       = length(var.public_subnet_ids)
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.proxy_instance_type
  subnet_id                   = var.public_subnet_ids[count.index]
  vpc_security_group_ids      = [var.proxy_sg_id]
  key_name                    = var.ssh_key_name
  associate_public_ip_address = true # Proxies need public IPs

  # User data to install Nginx and set up a basic configuration
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y nginx # Use standard yum install for nginx

              # Ensure the conf.d directory exists
              sudo mkdir -p /etc/nginx/conf.d/

              # Write an initial placeholder Nginx config (will be overwritten by remote-exec)
              echo 'server { listen 80; location / { proxy_pass http://127.0.0.1; } }' | sudo tee /etc/nginx/conf.d/proxy.conf

              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo systemctl status nginx # Check status to see if it started
              EOF

  tags = {
    Name             = "NginxProxy-${count.index + 1}"
    AvailabilityZone = var.availability_zones[count.index]
  }

  # Remote-exec to update Nginx config with Internal ALB DNS name
  
  provisioner "remote-exec" {
    # Add a sleep to give Nginx a moment to fully start, though 'systemctl enable' usually ensures it's ready.
    # This can sometimes help with race conditions.
    # Also, check if the directory exists before attempting to write.
    inline = [
      "echo 'Updating Nginx configuration to reverse proxy to Internal ALB...'",
      "sudo mkdir -p /etc/nginx/conf.d/", # Ensure directory exists (redundant, but safe)
      # Dynamically set the proxy_pass to the internal ALB DNS name
      "echo 'server { listen 80; location / { proxy_pass http://${var.internal_alb_dns_name}; } }' | sudo tee /etc/nginx/conf.d/proxy.conf",
      "sudo systemctl restart nginx || sudo systemctl start nginx", # Try restart, if fail, try start
      "sudo systemctl status nginx" # Check status after attempt to restart/start
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user" # Default user for Amazon Linux AMIs
      private_key = file(pathexpand("~/.ssh/${var.ssh_key_name}.pem"))
      host        = self.public_ip
      # Add timeout to connection block if network issues are suspected, default is usually fine
      # timeout = "5m"
    }
  }
}

resource "aws_lb_target_group_attachment" "proxy_attachment" {
  count            = length(var.public_subnet_ids)
  target_group_arn = var.public_alb_target_group_arn
  target_id        = aws_instance.proxy[count.index].id
  port             = 80
}