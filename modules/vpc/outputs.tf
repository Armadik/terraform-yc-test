output "vpc_network_default" {
  value = yandex_vpc_network.default
}

output "vpc_network_default_id" {
  value = yandex_vpc_network.default.id
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
