# modules/internal_alb/main.tf
resource "aws_lb" "internal_alb" {
  name               = "my-internal-app-alb" # Corrected name: Removed "internal-" prefix
  internal           = true # Internal-facing
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.private_subnet_ids

  tags = {
    Name = "InternalAppALB"
  }
}

resource "aws_lb_target_group" "internal_alb_tg" {
  name     = "internal-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200-499"
  }

  tags = {
    Name = "InternalALBTG"
  }
}

resource "aws_lb_listener" "internal_http_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.internal_alb_tg.arn
    type             = "forward"
  }
}