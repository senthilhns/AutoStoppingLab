terraform {
  required_providers {
    harness = {
      source  = "harness/harness"
      version = "0.37.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "harness" {}

provider "aws" {
  region = var.region
}
