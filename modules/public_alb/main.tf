resource "aws_lb" "public_alb" {
  name               = "public-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "PublicWebALB"
  }
}

resource "aws_lb_target_group" "public_alb_tg" {
  name     = "public-alb-tg"
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
    Name = "PublicALBTG"
  }
}

resource "aws_lb_listener" "public_http_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.public_alb_tg.arn
    type             = "forward"
  }
}