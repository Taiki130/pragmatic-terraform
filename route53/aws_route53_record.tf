resource "aws_route53_record" "example" {
  zone_id = data.aws_route53.example.zone_id
  name    = data.aws_route53_zone.example.name
  type    = "A"

  alias {
    name                   = aws_lb.example.dns_name
    zone_id                = aws_lb.example.zone_id
    evaluate_target_health = true
  }
}

output "domain_name" {
  value = aws_route53_record.example.name
}

resource "aws_route53_record" "example_certificate" {
  name    = aws_acm_certificate.example.domain_validation_option[0].resource_record_name
  type    = aws_acm_certificate.example.domain_validation_option[0].resource_record_type
  records = [aws_acm_certificate.example.domain_validation_options[0].resource_record_value]
  zone_id = data.aws_route53_zone.example.id
  ttl     = 60
}

resource "aws_acm_certidicate_validation" "example" {
  certificate_arn         = aws_acm_certficate.example.arn
  validation_record_fqdns = [aws_route53_record.example_certificate.fqdn]
}