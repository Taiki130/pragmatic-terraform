# variable "example_instance_type" {
#   default = "t3.micro"
# }

# locals {
#   example_instance_type = "t3.nano"
# }

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_security_group" "example_ec2" {
  name = "example-ec2"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    member   = "noda"
    usercase = "studying for terraform"
  }
}

data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "example" {
  ami                    = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.example_ec2.id]

  tags = {
    member   = "noda",
    usercase = "studying for terraform"
  }

  user_data = file("./user_data.sh")
}

output "example_instance_dns" {
  value = aws_instance.example.public_dns
}
