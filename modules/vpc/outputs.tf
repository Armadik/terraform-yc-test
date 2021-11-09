output "yandex_vpc_network" {
  value = yandex_vpc_network.default
}

output "zone-a_subnet_id" {
  value = local.zone-a_subnet_id
}
/*
output "zone-b_subnet_id" {
  value = local.zone-b_subnet_id
}

output "zone-c_subnet_id" {
  value = local.zone-c_subnet_id
}
*/
