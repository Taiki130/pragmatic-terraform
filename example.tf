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

# 19.10
provider "random" {}

resource "random_string" "password" {
  length  = 32
  special = false
}