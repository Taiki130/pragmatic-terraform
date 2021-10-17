resource "aws_s3_bucket" "force_destroy" {
  buclet        = "force-destroy-pragmatic-terraform"
  force_destroy = true
}
