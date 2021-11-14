output "k8s-id" {
  description = "returns a string"
  value       = yandex_iam_service_account.k8s.id
}

output "k8snodes-id" {
  description = "returns a string"
  value       = yandex_iam_service_account.k8snodes.id
}


output "k8s-cluster-key" {
  description = "returns a string"
  value       = yandex_kms_symmetric_key.k8s-cluster-key.id
}