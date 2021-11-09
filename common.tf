// Импорт данных используемого каталога позволит использовать его имя,
// например при определении имени сервисного аккаунта.
data "yandex_resourcemanager_folder" "participant" {
  folder_id = local.folder_id
}
