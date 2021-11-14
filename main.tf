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

  # cluster_ipv4_range - (optional) is a type of string
  cluster_ipv4_range = null
  # description - (optional) is a type of string
  description = "K8s - test"
  # folder_id - (optional) is a type of string
  folder_id = var.folder_id
  # labels - (optional) is a type of map of string
  labels = {}
  # name - (optional) is a type of string
  name = "K8S-bot-test"
  # network_id - (required) is a type of string
  network_id = module.vpc.yandex_vpc_network_id
  # network_policy_provider - (optional) is a type of string
  network_policy_provider = null
  # node_ipv4_cidr_mask_size - (optional) is a type of number
  node_ipv4_cidr_mask_size = null
  # node_service_account_id - (required) is a type of string
  node_service_account_id = module.iam.k8snodes-id
  # release_channel - (optional) is a type of string
  release_channel = null
  # service_account_id - (required) is a type of string
  service_account_id = module.iam.k8s-id
  # service_ipv4_range - (optional) is a type of string
  service_ipv4_range = null

  kms_provider = [{
    key_id = module.iam.k8s-cluster-key
  }]

  master = [{
    cluster_ca_certificate = null
    external_v4_address    = null
    external_v4_endpoint   = null
    internal_v4_address    = null
    internal_v4_endpoint   = null
    maintenance_policy = [{
      auto_upgrade = yes
      maintenance_window = [{
        day        = "friday"
        start_time = "10:00"
        duration   = "4h30m"
      }]
    }]
    public_ip = null
    regional = [{
      location = [{
        subnet_id = module.vpc.zone-a_subnet_id
        zone      = "ru-central1-a"
      }]
      region = null
    }]
    version = "1.18"
    version_info = [{
      current_version        = null
      new_revision_available = null
      new_revision_summary   = null
      version_deprecated     = null
    }]
    zonal = [{
      subnet_id = module.vpc.zone-a_subnet_id
      zone      = "ru-central1-a"
    }]
  }]

  timeouts = [{
    create = null
    delete = null
    read   = null
    update = null
  }]
}
