# Request ACM Certficate for TLS 
resource "aws_acm_certificate" "cert" {
    domain_name = var.subdomain_name
    validation_method = "DNS"

    lifecycle {
      create_before_destroy = true
    }

    tags = {
      "Name" = "${var.project_name}-cert"
    }
}

# Request Created Hosted Zone of original Domain name 
data "aws_route53_zone" "hosted_zone" {
    name = var.zone_name
    private_zone = false
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
    certificate_arn = aws_acm_certificate.cert.arn
    validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}