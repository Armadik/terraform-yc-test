terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "participant-terraform-state"
    key        = "yandex-scale-2021-kubernetes-workshop.tfstate"
    access_key = ""
    // Параметр 'secret_key' необходим, но не должен быть выставлен в коде,
    // т.к. код попадает в VCS, куда не должны попадать незашифрованные секреты.
    // Его необходимо выставить во время 'terraform init' передав параметр '-backend-config="secret_key=<secret_value>"'

    dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gc396lnv42reedkfr7/etnp1prrd0b0ku4c1ns1"
    dynamodb_table    = "tf_lock"

    // Параметры, которые для Yandex Cloud не имеют смысла, но их необходимо задать.
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    region                      = "us-east-1"
  }
}
