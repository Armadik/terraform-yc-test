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
resource "yandex_kubernetes_cluster" "cluster" {
  name        = "test-cluster"
  network_id  = var.network_id

  master {
    version = "1.19"
    zonal {
      zone      = var.zone
      subnet_id = var.subnet_id
    }

    public_ip = true

    maintenance_policy {
      auto_upgrade = true

    }
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id

  release_channel = "RAPID"
}