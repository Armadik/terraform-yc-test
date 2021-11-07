FOLDER_ID=$(yc config get folder-id)
(
set -x # Чтобы видеть команду перед её выводом
yc resource folder --id ${FOLDER_ID:?} get
yc vpc network list
yc vpc subnet list

yc iam service-account list
yc resource folder --id ${FOLDER_ID:?} list-access-bindings

yc kms symmetric-key list

yc k8s cluster list
yc k8s cluster --name workshop list-node-groups
yc k8s cluster --name workshop list-nodes
)

