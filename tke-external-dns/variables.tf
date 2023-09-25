variable "az" {
  type        = string
  description = "Available zone"
}

variable "sg_id" {
  type        = string
  description = "Security group id"
}

variable "tags" {
  type        = map(string)
  description = "Tags that need to add resources"
}

variable "enable_kube_config_file" {
  type        = bool
  default     = false
  description = "Wether to write local kube config file"
}

variable "kube_config_file" {
  type        = string
  default     = ""
  description = "Kube config file path, work with enable_kube_config_file"
}

variable "enable_nat" {
  type        = bool
  default     = false
  description = "Enable NAT gateway"
}

variable "enable_bandwidth_package" {
  type        = bool
  default     = false
  description = "Enable bandwidth_package"
}

variable "cluster_name" {
  type        = string
  description = "TKE cluster name"
}

variable "cluster_version" {
  type        = string
  description = "TKE cluster version"
  default     = "1.26.1"
}

variable "container_runtime" {
  type        = string
  description = "TKE container runtime"
  default     = "containerd"
}

variable "container_graph_path" {
  type        = string
  description = "Container storage on node machine"
  default     = "/var/lib/containerd"
}

variable "node_pool_name" {
  type        = string
  description = "TKE node pool's name"
  default     = "TKE node pool"
}

variable "node_pool_max" {
  type        = number
  description = "TKE node pool max size"
  default = 1
}

variable "node_pool_min" {
  type        = number
  description = "TKE node pool min size"
  default     = 1
}

variable "node_pool_desired_cap" {
  type        = number
  description = "TKE node pool desired capacity"
  default     = 1
}

variable "node_os" {
  type        = string
  description = "CVM instance operation system"
  default     = "tlinux3.2x86_64"
}

variable "node_instance_type" {
  type        = string
  description = "CVM instance type"
  default     = "S3.MEDIUM2"
}

variable "node_sg_ids" {
  type        = list(string)
  description = "Security group list for nodes"
}

variable "cloudflare_api_key" {
  type        = string
  description = "Cloudflare api key"
}

variable "cloudflare_api_email" {
  type        = string
  description = "Cloudflare api email"
}

variable "filter_domain" {
  type        = string
  description = "Argument --domain-filter for external-dns setup"
}
