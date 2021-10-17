resource "aws_vpc" "staging" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "public_staging" {
  vpc_id     = aws_vpc.staging.id
  cidr_block = "192.168.0.0/24"
}

output "vpc_id" {
  value = aws_vpc.staging.id
}

output "subnet_id" {
  value = aws_subnet.public_staging.id
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tfstate-pragmatic-terraform"
    key    = "network/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

resource "aws_instance" "server" {
  ami                    = "ami-0c3fd0f5d33134a76"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.server.id]
  subnet_id              = data.terraform_remote_state.network.outputs.subnet_id
}

resource "aws_security_group" "server" {
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
}