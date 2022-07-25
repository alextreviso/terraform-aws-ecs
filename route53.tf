data "aws_route53_zone" "devops-zone" {
  name         = "${var.domain}."
  private_zone = false
}

resource "aws_route53_record" "devops" {
  zone_id = data.aws_route53_zone.devops-zone.zone_id
  name    = "${var.dns_name}.${data.aws_route53_zone.devops-zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}