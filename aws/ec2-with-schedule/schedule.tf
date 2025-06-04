
// Get all EC2 instances with the specified Schedule tag
data "aws_instances" "vm_instances" {
  instance_tags = {
    Schedule = var.schedule_name_tag
  }
}

// Get all  RDS instances with the specified Schedule tag
data "aws_db_instances" "db_instances" {
  tags = {
    Schedule = var.schedule_name_tag
  }
}

// Harness autostopping rule for each EC2 instance that has the Schedule tag as var.schedule_name_tag
resource "harness_autostopping_rule_vm" "ec2_auto_stop_rule" {
  for_each = var.add_ec2_schedule_rules ? toset(data.aws_instances.vm_instances.ids) : []
  name               = "${each.key}-ec2-us-work-hours-schedule"
  cloud_connector_id = var.harness_cloud_connector_id
  idle_time_mins     = 5
  filter {
    vm_ids  = [each.key]
    regions = var.regions
  }
}

// Harness autostopping rule for each RDS instance that has the Schedule tag as var.schedule_name_tag
resource "harness_autostopping_rule_rds" "rds_auto_stop_rule" {
  for_each = var.add_rds_schedule_rules ? toset(data.aws_db_instances.db_instances.instance_identifiers) : []
  name               = "${each.key}-rds-us-work-hours-schedule"
  cloud_connector_id = var.harness_cloud_connector_id
  idle_time_mins     = 5
  database {
    id     = each.key
    region = var.region
  }
}

// Harness autostopping schedule that attaches all EC2 and RDS rules
// Between the star_time and end_time, ec2 instance and rds instances remain running
// on MON, TUE, WED, THU, FRI
resource "harness_autostopping_schedule" "auto_stop_schedule" {
  name          = "usworkhours"
  schedule_type = "uptime"
  time_zone     = "EST"

  repeats {
    days       = ["MON", "TUE", "WED", "THU", "FRI"]
    start_time = "11:00"
    end_time   = "17:00"
  }

  rules = concat(
    var.add_ec2_schedule_rules ? [for rule in harness_autostopping_rule_vm.ec2_auto_stop_rule : rule.id] : [],
    var.add_rds_schedule_rules ? [for rule in harness_autostopping_rule_rds.rds_auto_stop_rule : rule.id] : []
  )
}
