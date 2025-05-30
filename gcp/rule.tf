resource "harness_autostopping_gcp_proxy" "proxy" {
  name               = "${var.name}-gcp-proxy"
  cloud_connector_id = var.cloud_connector_id
  host_name          = "gcp-proxy.${local.tags.lb_hostname}"
  region             = var.region
  vpc                = "https://www.googleapis.com/compute/v1/projects/${var.gcp_project}/global/networks/${var.network_id}"
  zone               = var.zone
  security_groups    = ["http-server"]
  machine_type       = "e2-micro"
  subnet_id          = "https://www.googleapis.com/compute/v1/projects/${var.gcp_project}/regions/${var.region}/subnetworks/${var.subnetwork_id}"
  api_key            = var.api_key
  allocate_static_ip = true
}
resource "harness_autostopping_rule_vm" "vm" {
  name               = "${var.name}-gcp-vm"
  cloud_connector_id = var.cloud_connector_id
  idle_time_mins     = 10
  filter {
    vm_ids  = [var.instance_id]
    regions = [var.zone]
  }
  http {
    proxy_id = harness_autostopping_gcp_proxy.proxy.identifier
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