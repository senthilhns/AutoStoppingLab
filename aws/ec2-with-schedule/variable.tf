variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region to deploy resources in"
}


variable "regions" {
  type        = list(string)
  description = "List of AWS regions for Harness autostopping rules"
  default     = []
}

variable "harness_cloud_connector_id" {
  type    = string
  default = "AWS CCM connector for target AWS account"
}

variable "schedule_name_tag" {
  type    = string
  default = null
}

variable "add_ec2_schedule_rules" {
  type        = bool
  description = "Whether to create EC2 schedule rules in Harness"
  default     = true
}

variable "add_rds_schedule_rules" {
  type        = bool
  description = "Whether to create rds schedule rules in Harness"
  default     = true
}
