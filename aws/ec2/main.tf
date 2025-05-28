locals {
  name = var.name == null ? random_pet.name.id : lower(var.name)
  # use route53 domain if given, otherwise fallback to default ALB DNS name
  lb_hostname = var.alb_route53_dns_name != null ? var.alb_route53_dns_name : var.hostedzone == null ? aws_lb.alb[0].dns_name : "${local.name}.${data.aws_route53_zone.zone[0].name}"
  tags = {
    lb_hostname = local.lb_hostname
  }
}

data "harness_platform_current_account" "current" {}

data "aws_route53_zone" "zone" {
  count   = var.hostedzone == null ? 0 : 1
  zone_id = var.hostedzone
}

resource "aws_route53_record" "alb" {
  count   = var.hostedzone == null ? 0 : 1
  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = local.lb_hostname
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.alb[0].dns_name]
}

resource "random_pet" "name" {
  keepers = {
    ami = var.ami
  }
}