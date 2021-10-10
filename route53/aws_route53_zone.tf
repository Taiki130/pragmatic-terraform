data "aws_route53_zone" "example" {
  name = "example.com"
}

resource "aws_route53_zone" "test_example" {
  name = "test.example.com"
}
