resource "aws_lb_target_group" "http" {
  name     = "${var.name}-asg-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
}

resource "aws_security_group" "http" {
  name        = "${var.name}-alb"
  description = "Security group for whitelisting ports required for EcsSampleApp"
  vpc_id      = var.vpc

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "default"
  }
}
resource "aws_lb" "alb" {
  name               = "${var.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.http.id]
  subnets            = var.subnets

}

resource "aws_lb_listener" "ec2" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}
resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.ec2.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }

  condition {
    host_header {
      values = ["ec2rule.${local.tags.lb_hostname}"]
    }
  }
}

resource "aws_autoscaling_attachment" "asg" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.http.arn
}