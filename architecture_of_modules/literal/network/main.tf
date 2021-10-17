resource "aws_vpc" "staging" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Environment = "Staging"
  }
}

resource "aws_subnet" "public_staging" {
  vpc_id     = aws_vpc.staging.id
  cidr_block = "192.168.0.0/24"
  tags = {
    Environment   = "Staging"
    Accessibility = "Public"
  }
}

output "vpc_id" {
  value = aws_vpc.staging.id
}

output "subnet_id" {
  value = aws_subnet.public_staging.id
}