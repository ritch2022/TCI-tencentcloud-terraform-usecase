resource "kubernetes_service_account_v1" "dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_cluster_role_v1" "dns" {
  metadata {
    name = "external-dns"
  }
  rule {
    api_groups = [""]
    resources  = ["services", "endpoints", "pods"]
    verbs      = ["get", "watch", "list"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "watch", "list"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "dns" {
  metadata {
    name = "external-dns"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "external-dns"
  }
  subject {
    kind      = "ServiceAccount"
    namespace = "default"
    name      = "external-dns"
  }
}

locals {
  arg_filter_domain = format("--domain-filter=%s", var.filter_domain)
}

resource "kubernetes_deployment_v1" "dns" {
  metadata {
    name = "external-dns"
  }
  spec {
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "external-dns"
      }
    }
    template {
      metadata {
        labels = {
          app = "external-dns"
        }
      }
      spec {
        service_account_name = "external-dns"
        container {
          name  = "external-dns"
          image = "registry.k8s.io/external-dns/external-dns:v0.13.4"
          args = [
            local.arg_filter_domain,
            "--source=service",
            "--source=ingress",
            "--provider=cloudflare",
            "--cloudflare-dns-records-per-page=5000"
          ]
          env {
            name  = "CF_API_KEY"
            value = var.cloudflare_api_key
          }
          env {
            name  = "CF_API_EMAIL"
            value = var.cloudflare_api_email
          }
        }
      }
    }
  }
}
