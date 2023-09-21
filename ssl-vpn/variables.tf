variable "name" {
  type        = string
  default     = "demo"
  description = "Name"
}

variable "region" {
  type        = string
  default     = "ap-singapore"
  description = "Region"
}

variable "az" {
  type        = string
  default     = "ap-singapore-1"
  description = "Available zone"
}

variable "tags" {
  type        = map(string)
  description = "Tags that need to add resources"
}

variable "cloud_available_cidrs" {
  type        = list(string)
  description = "cidr can be accessed in cloud"
  validation {
    condition     = alltrue([for s in var.cloud_available_cidrs : can(cidrhost(s, 0))])
    error_message = "Must be valid IPv4 CIDR"
  }
}

variable "vpn_client_cidr" {
  type        = string
  description = "cidr used for vpn client"
  validation {
    condition     = can(cidrhost(var.vpn_client_cidr, 0))
    error_message = "Must be valid IPv4 CIDR"
  }
}
