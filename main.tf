module "vpc" {
  source    = "./modules/vpc/"
  folder_id = local.folder_id
  yc_token  = local.yc_token
}

/*
// VM - jenkins
module "jenkins" {
  source     = "./mgmt/services/jenkins/"
  user       = "jenkins"
  folder_id  = local.folder_id
  yc_token   = local.yc_token
  vpc_subnet = module.vpc.zone-a_subnet_id
}
*/

module "iam" {
  source     = "./global/iam/"
  folder_id  = local.folder_id
}

module "kubernetes_cluster" {
  source = "./modules/k8s"

  description = "K8s - test"
  # folder_id - (optional) is a type of string
  folder_id = var.folder_id
  # labels - (optional) is a type of map of string
  labels = {}
  # name - (optional) is a type of string
  name = "K8S-bot-test"
  # network_id - (required) is a type of string
  network_id = module.vpc.yandex_vpc_network_id
  # node_service_account_id - (required) is a type of string
  node_service_account_id = module.iam.k8snodes-id
  # service_account_id - (required) is a type of string
  service_account_id = module.iam.k8s-id# service_ipv4_range - (optional) is a type of string
}
