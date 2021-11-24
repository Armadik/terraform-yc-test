terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.66.0"
    }
  }
}

// Сервисный аккаунт Kubernetes кластера и его биндинг роли
resource "yandex_iam_service_account" "k8s" {
  name        = "k8s"
  description = "service account to manage k8s"
}

resource "yandex_resourcemanager_folder_iam_binding" "sa_k8s_editor" {
  folder_id = var.folder_id

  role = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s.id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_clusters_agent" {
  folder_id = var.folder_id

  role = "k8s.clusters.agent"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s.id}",
  ]
}


# KMS ключ шифрования секретов кластера Kubernetes
resource "yandex_kms_symmetric_key" "k8s-cluster-key" {
  name              = "k8s-cluster-key"
  description       = "KMS ключ шифрования секретов кластера Kubernetes"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}


// Сервисный аккаунт Kubernetes узлов и его биндинг роли
resource "yandex_iam_service_account" "k8snodes" {
  name        = "k8snodes"
  description = "service account to manage k8s-nodes "
}

resource "yandex_resourcemanager_folder_iam_binding" "container-registry_images_puller" {
  folder_id = var.folder_id

  role = "container-registry.images.puller"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8snodes.id}",
  ]
}
