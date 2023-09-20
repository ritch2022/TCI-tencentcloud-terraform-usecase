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

output "endpoint_ca_cert" {
  value       = tencentcloud_kubernetes_cluster_endpoint.endpoint.certification_authority
  description = "ca cert"
}

output "cluster_endpoint" {
  value       = tencentcloud_kubernetes_cluster.tke.cluster_external_endpoint
  description = "cluster_external_endpoint"
}

output "cluster_domain" {
  value       = tencentcloud_kubernetes_cluster.tke.domain
  description = "domain"
}

output "cluster_username" {
  value       = tencentcloud_kubernetes_cluster.tke.user_name
  description = "user_name"
}

output "cluster_ca_cert" {
  value = tencentcloud_kubernetes_cluster.tke.certification_authority
}

output "domain_1" {
  value = local.host1
}

output "domain_2" {
  value = local.host2
}
