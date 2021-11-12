/*

# Кластер Kubernetes
terraform import 'yandex_kubernetes_cluster.workshop' "$(yc k8s cluster get workshop --format json | jq .id -r)"

# Группа узлов Kubernetes
terraform import 'yandex_kubernetes_node_group.default' "$(yc k8s node-group get default --format json | jq .id -r)"
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
resource "yandex_kubernetes_cluster" "zonal_cluster_resource_name" {
  name        = "participant"
  description = "k8s - participant"

  network_id = "${yandex_vpc_network.network_resource_name.id}"

  master {
    version = "1.17"
    zonal {
      zone      = "${yandex_vpc_subnet.subnet_resource_name.zone}"
      subnet_id = "${yandex_iam_service_account.k8snodes.id}"
    }

    public_ip = true

    security_group_ids = ["${yandex_vpc_security_group.security_group_name.id}"]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = "${yandex_iam_service_account.k8s.id}"
  node_service_account_id = "${yandex_iam_service_account.k8snodes.id}"

  labels = {
    my_key       = "my_test_k8s"
    my_other_key = "my_other_test_k8s"
  }

  release_channel = "RAPID"
  network_policy_provider = "CALICO"

  kms_provider {
    key_id = "${yandex_kms_symmetric_key.k8s-cluster-key.id}"
  }
}