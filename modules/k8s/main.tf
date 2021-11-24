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

  depends_on = [
    var.service_account_name
  ]
}


resource "yandex_kubernetes_node_group" "cluster_node_group" {
  cluster_id  = yandex_kubernetes_cluster.cluster.id
  name        = "test-cluster-node"
  description = "description"
  version     = "1.19"

  labels = {
    "key" = "value"
  }

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      subnet_ids         = [var.subnet_id]
      }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}


locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${yandex_kubernetes_cluster.cluster.master[0].external_v4_endpoint}
    certificate-authority-data: ${base64encode(yandex_kubernetes_cluster.cluster.master[0].cluster_ca_certificate)}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: yc
  name: ycmk8s
current-context: ycmk8s
users:
- name: yc
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: yc
      args:
      - k8s
      - create-token
KUBECONFIG
}