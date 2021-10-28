#!/usr/bin/env bash
set -euo pipefail

SECRET_KEY=$(yc lockbox payload get --name terraform-state-secret-key --key secret_key)

terraform init --backend-config "secret_key=${SECRET_KEY:?}" "$@"
