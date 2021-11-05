//
output "zone" {
  value       = local.zone
  description = "Зона сетевого сегмента"
}

//
output "zone_subnet_id" {
  value       = local.zone_subnet_id
  description = "Id зоны сетевого сегмента"
}