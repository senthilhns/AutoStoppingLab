resource "aws_launch_template" "template" {
  image_id               = var.ami
  instance_type          = "t3.nano"
  user_data              = filebase64("userdata.tpl")
  vpc_security_group_ids = [aws_security_group.allow_http.id]
}

resource "aws_autoscaling_group" "asg" {
  name               = "${var.name}-asg"
  availability_zones = var.availability_zones
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.template.id
    version = aws_launch_template.template.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-asg"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}

