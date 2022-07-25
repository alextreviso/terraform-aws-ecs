data "aws_acm_certificate" "crt" {
  domain   = var.certificate
  statuses = ["ISSUED"]
}