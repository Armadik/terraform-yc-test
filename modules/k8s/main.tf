/*

*/
// Сервисный аккаунт Kubernetes кластера и его биндинг роли
resource "yandex_iam_service_account" "k8s" {
  name        = "k8s"
  description = "service account to manage k8s"
}

resource "yandex_resourcemanager_folder_iam_binding" "sa_k8s_editor" {
  folder_id = var.folder_id

  role = "k8s.editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s.id}",
  ]
}

// Сервисный аккаунт Kubernetes узлов и его биндинг роли
resource "yandex_iam_service_account" "k8snodes" {
  name        = "k8snodes"
  description = "service account to manage k8s-nodes "
}

resource "yandex_resourcemanager_folder_iam_binding" "sa_k8snodes_image_puller" {
  folder_id = var.folder_id

  role = "k8s.cluster-api.editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8snodes.id}",
  ]
}

# KMS ключ шифрования секретов кластера Kubernetes
resource "yandex_kms_symmetric_key" "k8s-cluster-key" {
  name              = "k8s-cluster-key"
  description       = "KMS ключ шифрования секретов кластера Kubernetes"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}

// Кластер Kubernetes
resource "yandex_kubernetes_cluster" "participant" {
  name        = "participant"
  description = "k8s - participant"

  network_id = yandex_vpc_network.k8s.id

  master {
    version = "1.17"
    zonal {
      zone      = yandex_vpc_subnet.subnet_k8s.zone
      subnet_id = yandex_vpc_subnet.subnet_k8s.id
    }

    public_ip = true

    security_group_ids = [yandex_vpc_security_group.group1.id]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.k8s.id
  node_service_account_id = yandex_iam_service_account.k8snodes.id

  labels = {
    my_key       = "my_test_k8s"
    my_other_key = "my_other_test_k8s"
  }

  release_channel = "RAPID"
  network_policy_provider = "CALICO"

  kms_provider {
    key_id = yandex_kms_symmetric_key.k8s-cluster-key.id
  }
}

// Группа узлов Kubernetes
resource "yandex_kubernetes_node_group" "my_node_group" {
  cluster_id  = yandex_kubernetes_cluster.participant.id
  name        = "name"
  description = "description"
  version     = "1.17"

  labels = {
    "key" = "value"
  }

  instance_template {
    platform_id = "standard-v2"


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