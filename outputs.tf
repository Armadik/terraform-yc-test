/*
output "ip-jenkins" {
  value = module.jenkins.external_ip_address_vm_1
}
*/

output "kubeconfig" {
  value = module.kubernetes_cluster.kubeconfig
}