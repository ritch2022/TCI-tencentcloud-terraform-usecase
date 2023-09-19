# 2 steps to create SSL VPN gateway:
# 1. create SSL VPN gateway of CCN type
# 2. bind the SSL VPN gateway to CCN instance, using terraform resource tencentcloud_ccn_attachment

resource "tencentcloud_vpn_gateway" "gw" {
  name        = var.name
  zone        = var.az
  bandwidth   = 5
  charge_type = "POSTPAID_BY_HOUR"
  type        = "SSL_CCN"
  tags        = var.tags
}

resource "tencentcloud_ccn" "main" {
  name        = var.name
  description = var.name
  qos         = "AG"
  charge_type = "POSTPAID"
  tags        = var.tags
}

resource "tencentcloud_ccn_attachment" "attachment" {
  ccn_id          = tencentcloud_ccn.main.id
  instance_id     = tencentcloud_vpn_gateway.gw.id
  instance_type   = "VPNGW"
  instance_region = var.region
}

resource "tencentcloud_vpn_ssl_server" "server" {
  # 对应的是 云端网段
  local_address = var.cloud_available_cidrs
  # 对应的是 客户端网段
  remote_address      = var.vpn_client_cidr
  ssl_vpn_server_name = var.name
  vpn_gateway_id      = tencentcloud_vpn_gateway.gw.id
}

resource "tencentcloud_vpn_ssl_client" "client" {
  ssl_vpn_server_id   = tencentcloud_vpn_ssl_server.server.id
  ssl_vpn_client_name = var.name
}
