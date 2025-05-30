# Create instance that serves traffic on port 80 (nginx)

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2" {
  ami                    = var.ami != null ? var.ami : data.aws_ami.ubuntu.image_id
  instance_type          = "t3.micro"
  user_data              = file("userdata.tpl")
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  subnet_id              = var.ec2_subnet
  tags = {
    Name = "${local.name}-instance"
  }
}
