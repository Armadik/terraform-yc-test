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

resource "yandex_kubernetes_node_group" "my_node_group" {
  cluster_id  = var.cluster
  name        = "name"
  description = "description"
  version     = "1.19"

  instance_template {
    platform_id = "standard-v2"
    nat         = true

    resources {
      memory = 4
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

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    # maintenance_window {
    #   day        = "monday"
    #   start_time = "15:00"
    #   duration   = "3h"
    # }

    # maintenance_window {
    #   day        = "friday"
    #   start_time = "10:00"
    #   duration   = "4h30m"
    # }
  }
  scale_policy {}
}