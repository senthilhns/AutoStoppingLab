
data "aws_instances" "this" {
  instance_tags = {
    Schedule = var.ec2_schedule_name_tag
  }
}

resource "harness_autostopping_rule_vm" "ec2_as_rule" {
  for_each           = toset(data.aws_instances.this.ids)
  name               = "${each.key}-us-work-hours-schedule"
  cloud_connector_id = var.harness_cloud_connector_id
  idle_time_mins     = 5
  filter {
    vm_ids = [each.key]
    regions = var.regions
  }
}

resource "harness_autostopping_schedule" "this" {
  name          = "usworkhours"
  schedule_type = "uptime"
  time_zone     = "EST"

  repeats {
    days       = ["MON", "TUE", "WED", "THU", "FRI"]
    start_time = "11:00"
    end_time   = "17:00"
  }

  rules = concat([
    for rule in harness_autostopping_rule_vm.ec2_as_rule : rule.id
  ] /* , [
    for rule in harness_autostopping_rule_rds.this : rule.id
  ]*/)
}
