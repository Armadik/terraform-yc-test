# Авторизация в облачной консоли и настройка `yc` CLI

## Настройка yc

Получим и сохраним в env переменную токен для работы с Yandex Cloud.

Кликнем на блок кода, ниже, чтобы его скопировать. Вставим в терминал, но не будем нажимать `enter`:
```bash
# После символа '=' нужно будет вставить полученный токен
OAUTH_TOKEN=
```

Несколько приёмов использования командной строки которые будут встречаться далее:
* Получение значения переменной с добавлением `:?` к имени, вроде `${VAR_NAME:?}`, требует чтобы переменная была
  выставлена ранее
* Вызов `yc` CLI с флагом `--format json` выводит объект в формате JSON
* `| jq .id -r` возвращает JSON значение поля `id`

Работать с настройками `yc` CLI будем
используя [команды не интерактивной настройки](https://cloud.yandex.ru/docs/cli/cli-ref/managed-yc/config/)
- `yc config`. Создадим профиль `yc` CLI в котором будем работать и выставим туда токен
```bash
yc config profile create workshop
yc config set token ${OAUTH_TOKEN:?}
echo "Token set to '$(yc config get token)'"
```

Проверим, что токен скопирован корректно, и появился доступ к Облаку в котором будем работать:
```bash
yc resource cloud list
```

Выставим ID Облака в конфиг `yc` CLI
```bash
CLOUD_NAME=cloud-practicum-k8s
CLOUD_ID=$(yc resource cloud get --name ${CLOUD_NAME:?} --format json | jq .id -r)
yc config set cloud-id ${CLOUD_ID:?}
echo "В конфиг yc CLI добавлен ID Облака: '$(yc config get cloud-id)'"
```

Создаем каталог
```bash
echo "Ваш каталог:"
FOLDER=$(yc resource folder list --format json | jq '.[]' -c | grep <твоя папка>)
jq <<< "$FOLDER" '"Имя: " + .name + " " + "ID: " + .id' -r
```

Сохраним его ID в конфиг yc CLI:
```bash
yc config set folder-id $(jq -r <<< "$FOLDER" .id)
echo "В конфиг yc CLI добавлен ID каталога: '$(yc config get folder-id)'"
```

```bash
source ./set_tf_vars_from_yc_config.sh
```


# Импорт существующих ресурсов

Познакомимся с ресурсами в каталоге:
```bash
 ./show_resoursec.sh
```
Для этого, для каждого ресурса нужно выполнить команду `terraform import` передав имя в terraform и идентификатор в
облаке:
```bash
# Сеть и подсети
terraform import 'yandex_vpc_network.default' "$(yc vpc network get default --format json | jq .id -r)"
terraform import 'yandex_vpc_subnet.default[0]' "$(yc vpc subnet get default-a --format json | jq .id -r)"
terraform import 'yandex_vpc_subnet.default[1]' "$(yc vpc subnet get default-b --format json | jq .id -r)"
terraform import 'yandex_vpc_subnet.default[2]' "$(yc vpc subnet get default-c --format json | jq .id -r)"

FOLDER_NAME="$(yc resource folder get "$(yc config get folder-id)" --format json | jq .name -r)"

# Сервисный аккаунт Kubernetes кластера и его биндинг роли
terraform import 'yandex_iam_service_account.k8s' "$(yc iam service-account get "${FOLDER_NAME:?}-k8s" --format json | jq .id -r)"
terraform import 'yandex_resourcemanager_folder_iam_binding.sa_k8s_editor' "$(yc config get folder-id) editor"

# Сервисный аккаунт Kubernetes узлов и его биндинг роли
terraform import 'yandex_iam_service_account.k8s_nodes' "$(yc iam service-account get "${FOLDER_NAME:?}-k8s-nodes" --format json | jq .id -r)"
terraform import 'yandex_resourcemanager_folder_iam_binding.sa_k8s_nodes_image_puller' "$(yc config get folder-id) container-registry.images.puller"

# KMS ключ шифрования секретов кластера Kubernetes
terraform import 'yandex_kms_symmetric_key.k8s_cluster_workshop' "$(yc kms symmetric-key --name k8s-cluster-workshop get --format json | jq .id -r)"

# Кластер Kubernetes
terraform import 'yandex_kubernetes_cluster.workshop' "$(yc k8s cluster get workshop --format json | jq .id -r)"

# Группа узлов Kubernetes
terraform import 'yandex_kubernetes_node_group.default' "$(yc k8s node-group get default --format json | jq .id -r)"
```

Актуальное состояние ресурсов:
```bash
terraform plan
```



