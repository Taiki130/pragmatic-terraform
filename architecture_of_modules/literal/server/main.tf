locals {
  vpc_id    = "vpc-0e3b095e9b542004c"
  subnet_id = "subnet-061f6902b04084ae0"
}

resource "aws_instance" "server" {
  ami                    = "ami-0c3fd0f5d33134a76"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.server.id]
  subnet_id              = local.subnet_id
}

resource "aws_security_group" "server" {
  vpc_id = local.vpc_id
}

#############################################

data "aws_vpc" "staging" {
  tags = {
    Environment = "Staging"
  }
}

data "aws_subnet" "public_staging" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.staging.id]
  }

  filter {
    name   = "cidr-block"
    values = ["192.168.0.0/24"]
  }
}

resource "aws_instance" "server" {
  ami                    = "ami-0c3fd0f5d33134a76"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.server.id]
  subnet_id              = data.aws_subnet.public_staging.id
}

resource "aws_security_group" "server" {
  vpc_id = data.aws_vpc.staging.id
}