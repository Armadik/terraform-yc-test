module "jenkins" {
  source = "./mgmt/services/jenkins/"
  user = "jenkins"
  folder_id = local.folder_id
  yc_token = local.yc_token
  vpc_subnet = yandex_vpc_subnet.default.id
}