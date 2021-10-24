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
И все с виду.