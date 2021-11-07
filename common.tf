// Импорт данных используемого каталога позволит использовать его имя,
// например при определении имени сервисного аккаунта.
data "yandex_resourcemanager_folder" "participant" {
  folder_id = local.folder_id
}

resource "yandex_vpc_network" "default" {
  name = "default"
}

// В реальности, часто удобно создать подсети сразу во всех зонах.
// Чтобы не копировать несколько блоков, удобно создать их через конструкцию 'count'.
// Например, так определить подсети:
//   default-a: 10.0.0.0/16
//   default-b: 10.1.0.0/16
//   default-c: 10.2.0.0/16
locals {
  //zone_letters = ["a", "b", "c"]
  zone_letters = ["a"]
  zones        = [for letter in local.zone_letters : "ru-central1-${letter}"]
}
resource "yandex_vpc_subnet" "default" {
  count          = 1
  network_id     = yandex_vpc_network.default.id
  name           = "default-${local.zone_letters[count.index]}"
  zone           = local.zones[count.index]
  v4_cidr_blocks = ["10.${count.index}.0.0/16"]
}

locals {
  zone = local.zones
}

