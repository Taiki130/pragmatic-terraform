resource "aws_s3_bucket" "artifact" {
  bucket = "artifact-pragmatic-terraform"

  lifecyclec_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}