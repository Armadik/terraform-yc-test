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
  service_account_id          = module.iam.k8s-service-account-id
  subnet_id                   = module.vpc.zone-a_subnet_id
  zone                        = var.zone
  network_id                  = module.vpc.vpc_network_default_id
  kms-key                     = module.iam.k8s-cluster-key-id
  node_service_account_id     = module.iam.k8s-nodes-service-account-id
}
