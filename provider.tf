terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  folder_id = local.folder_id
  token     = local.yc_token
  zone      = "ru-central1-a"
}
