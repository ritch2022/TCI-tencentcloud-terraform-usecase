terraform {
  required_version = ">=1.5"
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">=1.81.30"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.23.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.4.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kube_config_file
}
