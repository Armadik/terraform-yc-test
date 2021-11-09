module "vpc" {
  source    = "./modules/vpc/"
  folder_id = local.folder_id
  yc_token  = local.yc_token
}

module "jenkins" {
  source     = "./mgmt/services/jenkins/"
  user       = "jenkins"
  folder_id  = local.folder_id
  yc_token   = local.yc_token
  vpc_subnet = module.vpc.zone-a_subnet_id
}


