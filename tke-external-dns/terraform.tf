terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.23.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kube_config_file
}
