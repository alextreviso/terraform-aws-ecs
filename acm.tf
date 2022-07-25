data "aws_acm_certificate" "crt" {
  domain   = var.domain
  statuses = ["ISSUED"]
}