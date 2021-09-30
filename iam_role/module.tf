variable "name" {}
variable "policy" {}
variable "identifier" {}

resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = {
    member  = "noda"
    usecase = "studying for terraform"
  }
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type       = "Service"
      identifier = [var.identifier]
    }
  }
}

resource "aws_iam_policy" "default" {
  name   = var.name
  policy = var.policy
  tags = {
    member  = "noda"
    usecase = "studying for terraform"
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
  tags = {
    member  = "noda"
    usecase = "studying for terraform"
  }
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}

output "iam_role_nam" {
  value = aws_iam_role.default.name
}