#!/bin/bash
set -eo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
source ${REPO_ROOT}/scripts/deploy/set_env.sh

params='{"owner": "'$(babylond keys show $userKey -a)'"}'

bash ${REPO_ROOT}/scripts/deploy/instantiate.sh "astroport_native_coin_registry" "$params"