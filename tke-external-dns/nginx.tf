resource "kubernetes_deployment_v1" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "nginx" {
  metadata {
    name = "nginx-service"
  }
  spec {
    selector = {
      app = "nginx"
    }
    type = "NodePort"
    port {
      protocol = "TCP"
      port     = 80
    }
  }
}

locals {
  host1 = format("demo101.%s", var.filter_domain)
  host2 = format("demo202.%s", var.filter_domain)
}

resource "kubernetes_ingress_v1" "nginx" {
  metadata {
    name = "nginx"
    annotations = {
      "kubernetes.io/ingress.class"                   = "qcloud"
      "kubernetes.io/ingress.internetMaxBandwidthOut" = "10"
      "ingress.cloud.tencent.com/pass-to-target"      = "true"
    }
  }
  spec {
    rule {
      host = local.host1
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "nginx-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
    rule {
      host = local.host2
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "nginx-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

