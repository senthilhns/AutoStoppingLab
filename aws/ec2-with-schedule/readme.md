# AWS - EC2 & RDS AutoStopping Schedule

This module creates Harness autostopping rules and schedules for existing EC2 and RDS instances based on a tag, allowing you to automatically manage uptime for cost savings.

## Setup

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your values.
2. [Configure AWS authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) for Terraform/OpenTofu.
3. [Configure Harness authentication](https://registry.terraform.io/providers/harness/harness/latest/docs) for Terraform/OpenTofu:
    - `HARNESS_ACCOUNT_ID`: your Harness account id
    - `HARNESS_PLATFORM_API_KEY`: API key with CCM admin permissions
4. Run `tofu plan` and `tofu apply` to create the rules and schedule.

## Variables

| Name | Description | Type | Example/Default |
|------|-------------|------|----------------|
| region | AWS region for resources | string | "us-west-2" |
| regions | List of AWS regions for Harness rules | list(string) | ["us-west-2"] |
| schedule_name_tag | Value of the `Schedule` tag to match | string | "as-test-schedule-01-tag" |
| harness_cloud_connector_id | Harness CCM cloud connector ID | string | "my-harness-connector" |
| add_ec2_schedule_rules | Enable EC2 autostopping rules | bool | true |
| add_rds_schedule_rules | Enable RDS autostopping rules | bool | true |

## Example `terraform.tfvars`

```hcl
region = "us-west-2"
regions = ["us-west-2"]
schedule_name_tag = "as-test-schedule-01-tag"
harness_cloud_connector_id = "my-harness-connector"
add_ec2_schedule_rules = true
add_rds_schedule_rules = true
```
