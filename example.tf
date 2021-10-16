# 19.3
variable "allow_ssh" {
  type = bool
}

resource "aws_security_group" "example" {
  name = "example"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "ingress" {
  count = var.allow_ssh ? 1 : 0

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example.id
}

output "allow_ssh_rule_id" {
  value = join("", aws_security_group_rule.ingress[*].id)
}
# https://www.terraform.io/docs/language/functions/join.html

# 19.4
module "allow_ssh" {
  source    = "./security_group"
  allow_ssh = true
}

output "allow_ssh_rule_id" {
  value = module.allow_ssh.allow_ssh_rule_id
}

# 19.5
module "disallow_ssh" {
  source    = "./security_group"
  allow_ssh = false
}

output "disallow_ssh_rule_id" {
  value = module.disallow_ssh.allow_ssh_rule_id
}

#19.6
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# 19.7
data "aws_region" "current" {}

output "region_name" {
  value = data.aws_region.current.name
}

# 19.8
data "aws_availability_zones" "available" {
  state = "available"
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

# 19.9
data "aws_elb_service_account" "current" {}

output "alb_service_account_id" {
  value = data.aws_elb_service_account.current.id
}

# $ terraform console
# > cidrsubnet("10.1.0.0/16", 8, 3)
# 10.1.3.0/24
# > exit

# > max(1, 100, 10)
# 100

# > substr("Pragmatic Terraform on AWS", 10, 9)
# Terraform

# > flatten([["Pragmatic"], ["Terraform", ["on", "AWS"]]])
# [
#   "Pragmatic",
#   "Terraform",
#   "on",
#   "AWS",
# ]

# > templatefile("${path.module}/install.sh", { package = "httpd" })

# 19.10
provider "random" {}

resource "random_string" "password" {
  length  = 32
  special = false
}

# 19.11
provider "random" {}

resource "random_string" "password" {
  length  = 32
  special = false
}

# 19.12
resource "aws_db_instance" "example" {
  engine              = "mysql"
  instance_class      = "db.t3.small"
  allocated_storage   = 20
  skip_final_snapshot = true
  username            = "admin"
  password            = random_string.password.result
}

# 19.13
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

provider "aws" {
  region = "ap-northeast-1"
}

# 19.14
resource "aws_vpc" "virginia" {
  provider   = aws.virginia
  cidr_block = "192.168.0.0/16"
}

resource "aws_vpc" "tokyo" {
  cidr_block = "192.168.0.0/16"
}

output "virginia_vpc" {
  value = aws_vpc.virginia.arn
}

output "tokyo_vpc" {
  value = aws_vpc.tokyo.arn
}

# 19.15
resource "aws_vpc" "default" {
  cidr_block = "192.168.0.0/16"
}

output "vpc_arn" {
  value = aws_vpc.default.arn
}

# 19.16
module "virginia" {
  source = "./vpc"

  providers = {
    aws = aws.virginia
  }
}

module "tokyo" {
  source = "./vpc"
}

output "module_virginia_vpc" {
  value = module.virginia.vpc_arn
}

output "module_tokyo_vpc" {
  value = module.tokyo.vpc_arn
}

# 19.17
variable "ports" {
  type = list(number)
}

resource "aws_security_group" "default" {
  name = "simple-sg"

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
      protocol    = "tcp"
    }
  }
}

# 19.18
module "simple_sg" {
  source = "./simple_security_group"
  ports  = [80, 443, 8080]
}

# 19.19
variable "ingress_rules" {
  type = map(
    object(
      {
        port        = number
        cidr_blocks = list(string)
      }
    )
  )
}

resource "aws_security_group" "default" {
  name = "complex-sg"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      cidr_blocks = ingress.value.cidr_blocks
      description = "Allow ${ingress.key}"
      protocol    = "tcp"
    }
  }
}

# 19.20
module "complex_sg" {
  source = "./complex_security_group"

  ingress_rules = {
    http = {
      port        = 80
      cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    }
    https = {
      port        = 443
      cidr_blocks = ["0.0.0.0/0"]
    }
    redirect_http_to_https = {
      port        = 8080
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}