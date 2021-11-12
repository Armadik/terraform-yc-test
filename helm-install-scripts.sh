#!/usr/bin/env bash

set -euxo pipefail

FOLDER_ID="$(yc config get folder-id)"
FOLDER_NAME="$(yc resource folder get "$FOLDER_ID" --format json | jq .name -r)"

kubectl create namespace dev-test || true

if ! kubectl get secret -n dev-test yc-key; then
  KEY_FILE=sa-key.json
  yc iam key create --service-account-name "${SA_NAME:?}" --output "$KEY_FILE"
  kubectl delete secret -n dev-test yc--key || true
  kubectl create secret generic -n dev-test yc-key \
    --from-file="${KEY_FILE}"
  rm -rf "${KEY_FILE}"
fi


if ! helm status -n dev-test yc-test; then
  CHART_VERSION=v0.0.6
  export HELM_EXPERIMENTAL_OCI=1

  if [[ ! -f ./yc-alb-ingress-controller/ ]]; then
    helm chart pull "cr.yandex/crpsjg1coh47p81vh2lc/yc-alb-ingress-controller-chart:${CHART_VERSION}"
    helm chart export "cr.yandex/crpsjg1coh47p81vh2lc/yc-alb-ingress-controller-chart:${CHART_VERSION}"
  fi

  CLUSTER_ID=$(yc k8s cluster get workshop --format json | jq .id)
  helm install \
    --namespace yc-alb-ingress \
    --set "folderId=${FOLDER_ID:?}" \
    --set "clusterId=${CLUSTER_ID:?}" \
    yc-alb-ingress-controller ./yc-alb-ingress-controller/

  kubectl rollout status -n yc-alb-ingress deployment/yc-alb-ingress-controller
fi
