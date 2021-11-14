output "yandex_vpc_network" {
  value = yandex_vpc_network.default
}

output "yandex_vpc_network_id" {
  value = yandex_vpc_network.default.id
}

output "zone-a_subnet_id" {
  value = local.zone-a_subnet_id
}

output "zone-a" {
  value = local.zone-a
}

/*
output "zone-b_subnet_id" {
  value = local.zone-b_subnet_id
}

output "zone-c_subnet_id" {
  value = local.zone-c_subnet_id
}
*/
