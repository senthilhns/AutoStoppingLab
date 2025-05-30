provider "kubernetes" {
  config_path = "~/.kube/config"
}
provider "kubectl" {
  apply_retry_count = 15
}
terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}