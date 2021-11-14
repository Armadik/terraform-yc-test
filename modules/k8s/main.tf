/*

*/
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.66.0"
    }
  }
}

# yandex_kubernetes_cluster

resource "yandex_kubernetes_cluster" "zonal_k8s_cluster" {
  name        = "my-cluster"
  description = "my-cluster description"
  network_id = yandex_vpc_network.k8s-mdb-network.id

  master {
    version = "1.18"
    zonal {
      zone      = yandex_vpc_subnet.k8s-mdb-subnet.zone
      subnet_id = yandex_vpc_subnet.k8s-mdb-subnet.id
    }
    public_ip = true
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.node_service_account_id
  release_channel = "STABLE"
}

