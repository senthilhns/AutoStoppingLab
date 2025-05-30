variable "name" {
  type        = string
  description = "A unique key to use for all resource. If not set a random name is generated"
  default     = null
}

variable "alb_subnets" {
  type        = list(string)
  description = "Subnet to place ALB in. Should be routable so you can access the application"
}

variable "ec2_subnet" {
  type        = string
  description = "Subnet to place EC2 in"
}

variable "vpc" {
  type        = string
  description = "ID of existing VPC"
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region to deploy resources in"
}

variable "ami" {
  type        = string
  default     = "ami-0efcece6bed30fd98"
  description = "Ubuntu ami (default is for us-west-2)"
}

variable "hostedzone" {
  type        = string
  default     = null
  description = "Hosted zone id to use for application routing. If not set will use default ALB url"
}

variable "alb_arn" {
  type        = string
  description = "An existing ALB arn to use. If not set one will be created for you"
  default     = null
}

variable "harness_cloud_connector_id" {
  type    = string
  default = "AWS CCM connector for target AWS account"
}

variable "alb_certificate_arn" {
  type        = string
  description = "Alb certificate ARN"
  default     = null
}

variable "alb_route53_dns_name" {
  type        = string
  description = "alb dns name added in route 53"
  default     = null
}
