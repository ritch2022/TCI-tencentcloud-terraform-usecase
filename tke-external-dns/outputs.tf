output "endpoint_cluster_endpoint" {
  value       = tencentcloud_kubernetes_cluster_endpoint.endpoint.cluster_external_endpoint
  description = "cluster_external_endpoint"
}

output "endpoint_domain" {
  value       = tencentcloud_kubernetes_cluster_endpoint.endpoint.domain
  description = "domain"
}

output "endpoint_username" {
  value       = tencentcloud_kubernetes_cluster_endpoint.endpoint.user_name
  description = "user_name"
}

output "domain_1" {
  value       = local.host1
  description = "domain name for host1"
}

output "domain_2" {
  value       = local.host2
  description = "domain name for host2"
}
