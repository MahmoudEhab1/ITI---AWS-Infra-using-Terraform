data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "backend_ws" {
  count                  = length(var.private_subnet_ids)
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.backend_instance_type
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.backend_sg_id]
  key_name               = var.ssh_key_name
  associate_public_ip_address = false # Private instances should not have public IPs

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              # Install Python and Flask for a simple example
              sudo yum install -y python3 python3-pip
              sudo pip3 install Flask gunicorn
              # Create a simple Flask app for testing
              echo 'from flask import Flask' | sudo tee /home/ec2-user/app.py
              echo 'app = Flask(__name__)' | sudo tee -a /home/ec2-user/app.py
              echo '@app.route("/")' | sudo tee -a /home/ec2-user/app.py
              echo 'def hello_world():' | sudo tee -a /home/ec2-user/app.py
              echo '    return "<p>Hello, World from Backend Instance ${count.index + 1}!</p>"' | sudo tee -a /home/ec2-user/app.py
              echo 'if __name__ == "__main__":' | sudo tee -a /home/ec2-user/app.py
              echo '    app.run(host="0.0.0.0", port=80)' | sudo tee -a /home/ec2-user/app.py

              # Run Flask app with Gunicorn (replace with your actual app start command)
              sudo chown ec2-user:ec2-user /home/ec2-user/app.py
              sudo su - ec2-user -c "gunicorn -w 4 -b 0.0.0.0:80 app:app --daemon"
              EOF

  tags = {
    Name = "BackendWS-${count.index + 1}"
    AvailabilityZone = var.availability_zones[count.index]
  }

  provisioner "file" {
    source      = var.backend_app_files_path # Local path
    destination = "/home/ec2-user/backend_app/" # Remote path on EC2

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(pathexpand("~/.ssh/${var.ssh_key_name}.pem"))
      host        = self.private_ip
      bastion_host        = var.proxy_public_ips[count.index]
      bastion_user        = "ec2-user"
      bastion_private_key = file(pathexpand("~/.ssh/${var.ssh_key_name}.pem"))
      # Using bastion_host to proxy SSH through the public proxy instance
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod -R 755 /home/ec2-user/backend_app",
      "pkill gunicorn || true",
      "sudo su - ec2-user -c 'nohup gunicorn -w 4 -b 0.0.0.0:80 app:app --chdir /home/ec2-user/backend_app &'",
      "echo 'Backend application files copied and application restarted.'"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(pathexpand("~/.ssh/${var.ssh_key_name}.pem"))
      host        = self.private_ip
      bastion_host        = var.proxy_public_ips[count.index]
      bastion_user        = "ec2-user"
      bastion_private_key = file(pathexpand("~/.ssh/${var.ssh_key_name}.pem"))
      # Using bastion_host to proxy SSH through the public proxy instance
    }
  }
}

resource "aws_lb_target_group_attachment" "backend_attachment" {
  count            = length(aws_instance.backend_ws)
  target_group_arn = var.internal_alb_target_group_arn
  target_id        = aws_instance.backend_ws[count.index].id
  port             = 80
}