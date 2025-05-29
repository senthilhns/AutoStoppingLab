resource "harness_autostopping_azure_gateway" "proxy" {
  name               = "import_test"
  cloud_connector_id = "cloud_connector_id"
  host_name          = "host_name"
  region             = "westus2"
  resource_group     = "test_resource_group"
  app_gateway_id     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Network/applicationGateways/${var.gateway_id}"
  certificate_id     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Network/applicationGateways/${var.gateway_id}/sslCertificates/${var.certificate_name}"
  azure_func_region  = var.region
  vpc                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Network/virtualNetworks/${var.vnet}"
}
resource "harness_autostopping_rule_vm" "vm" {
  name               = "${var.name}-gcp-vm"
  cloud_connector_id = var.cloud_connector_id
  idle_time_mins     = 10
  filter {
    vm_ids = ["/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Compute/virtualMachines/${var.instance_id}"
    ]
    regions = [var.region]
  }
  http {
    proxy_id = harness_autostopping_azure_gateway.proxy.identifier
    routing {
      source_protocol = "http"
      target_protocol = "http"
      source_port     = 80
      target_port     = 80
      action          = "forward"
    }
    health {
      protocol         = "http"
      port             = 80
      path             = "/"
      timeout          = 30
      status_code_from = 200
      status_code_to   = 299
    }
  }
  custom_domains = ["35.239.247.160.nip.io"]
}