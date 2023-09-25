provider "tencentcloud" {}

locals {
  name                   = "heyheyhey"
  need_nat               = var.enable_nat ? 1 : 0
  need_bandwidth_package = var.enable_bandwidth_package ? 1 : 0
  need_kube_config_file  = var.enable_kube_config_file ? 1 : 0
}

resource "tencentcloud_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  name       = local.name
  tags       = var.tags
}

resource "tencentcloud_subnet" "intranet" {
  cidr_block        = "10.0.1.0/24"
  name              = "${local.name}-subnet"
  availability_zone = var.az
  vpc_id            = tencentcloud_vpc.this.id
  tags              = var.tags
  route_table_id    = tencentcloud_route_table.rt.id
}

resource "tencentcloud_route_table" "rt" {
  name   = "${local.name}-rt"
  vpc_id = tencentcloud_vpc.this.id
  tags   = var.tags
}

resource "tencentcloud_route_table_entry" "entry" {
  count                  = local.need_nat
  route_table_id         = tencentcloud_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  next_type              = "NAT"
  next_hub               = tencentcloud_nat_gateway.nat[0].id
}

resource "tencentcloud_eip" "eip" {
  count = local.need_nat
  name  = "${local.name}-eip"
  tags  = var.tags
}

resource "tencentcloud_nat_gateway" "nat" {
  count            = local.need_nat
  name             = "${local.name}-nat"
  tags             = var.tags
  vpc_id           = tencentcloud_vpc.this.id
  assigned_eip_set = [tencentcloud_eip.eip[0].public_ip]
}

resource "tencentcloud_vpc_bandwidth_package" "tke" {
  count                  = local.need_bandwidth_package
  bandwidth_package_name = "tke"
  network_type           = "BGP"
  charge_type            = "BANDWIDTH_POSTPAID_BY_DAY"
  internet_max_bandwidth = 50
  tags                   = var.tags
}


resource "tencentcloud_kubernetes_cluster" "tke" {
  cluster_name      = var.cluster_name
  cluster_version   = var.cluster_version
  container_runtime = var.container_runtime
  docker_graph_path = var.container_graph_path

  vpc_id       = tencentcloud_vpc.this.id
  cluster_cidr = "10.31.0.0/16"

  auto_upgrade_cluster_level = true

  tags = var.tags
  labels = {
    tke = var.cluster_name
  }
}

resource "tencentcloud_kubernetes_cluster_endpoint" "endpoint" {
  cluster_id = tencentcloud_kubernetes_cluster.tke.id

  cluster_internet                = true
  cluster_internet_security_group = var.sg_id
  cluster_intranet                = false
  # cluster_intranet_subnet_id      = tencentcloud_subnet.intranet.id

  depends_on = [
    tencentcloud_kubernetes_node_pool.nodes
  ]
}

resource "tencentcloud_kubernetes_node_pool" "nodes" {
  depends_on = [
    tencentcloud_kubernetes_cluster.tke
  ]

  name       = var.node_pool_name
  cluster_id = tencentcloud_kubernetes_cluster.tke.id
  vpc_id     = tencentcloud_vpc.this.id
  subnet_ids = [tencentcloud_subnet.intranet.id]

  max_size         = var.node_pool_max
  min_size         = var.node_pool_min
  retry_policy     = "INCREMENTAL_INTERVALS"
  desired_capacity = var.node_pool_desired_cap
  # 
  enable_auto_scale        = true
  multi_zone_subnet_policy = "EQUALITY"

  node_os              = var.node_os
  delete_keep_instance = false


  auto_scaling_config {
    instance_type              = var.node_instance_type
    system_disk_type           = "CLOUD_SSD"
    system_disk_size           = 50
    enhanced_monitor_service   = false
    enhanced_security_service  = false
    orderly_security_group_ids = var.node_sg_ids
    host_name_style            = "UNIQUE"
    host_name                  = "taiko-tke-host"
    instance_name              = "taiko-tke"

    data_disk {
      disk_type            = "CLOUD_SSD"
      disk_size            = 100
      delete_with_instance = true
    }

    public_ip_assigned         = true
    bandwidth_package_id       = var.enable_bandwidth_package ? tencentcloud_vpc_bandwidth_package.tke[0].id : ""
    internet_charge_type       = var.enable_bandwidth_package ? "BANDWIDTH_PACKAGE" : "TRAFFIC_POSTPAID_BY_HOUR"
    internet_max_bandwidth_out = 10
    key_ids                    = ["skey-29neeijb", "skey-kt59rout"]
  }

  # CBS init related configuration
  node_config {
    data_disk {
      disk_type             = "CLOUD_SSD"
      disk_size             = 100
      file_system           = "ext4"
      mount_target          = var.container_graph_path
      auto_format_and_mount = true
    }
    docker_graph_path = var.container_graph_path
    extra_args = [
      "root-dir=/var/lib/kubelet"
    ]
  }
  labels = {
    tke = var.cluster_name
  }
}

# lcoal file storage
resource "local_file" "config" {
  count      = local.need_kube_config_file
  content    = tencentcloud_kubernetes_cluster.tke.kube_config
  filename   = var.kube_config_file
  depends_on = [tencentcloud_kubernetes_cluster_endpoint.endpoint]
}
