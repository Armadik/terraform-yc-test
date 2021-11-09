// Оставляем одну подсеть для тестов в зоне - "a"
resource "yandex_vpc_network" "default" {
  name = "default"
}

resource "yandex_vpc_subnet" "subnet_a" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}
/*
resource "yandex_vpc_subnet" "subnet_b" {
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.2.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet_c" {
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.3.0.0/24"]
}
*/
locals {
  zone-a = yandex_vpc_subnet.subnet_a
  //zone-b = yandex_vpc_subnet.subnet_b
  //zone-c = yandex_vpc_subnet.subnet_c
  zone-a_subnet_id = yandex_vpc_subnet.subnet_a.id
  //zone-b_subnet_id = yandex_vpc_subnet.subnet_b.id
  //zone-c_subnet_id = yandex_vpc_subnet.subnet_c.id
}