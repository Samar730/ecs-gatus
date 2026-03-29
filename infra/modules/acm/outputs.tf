output "certificate_arn" {
    description = "ARN of Certficate for sudomain"
    value = aws_acm_certificate.cert.arn
}