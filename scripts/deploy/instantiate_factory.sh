#!/bin/bash
set -eo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
source ${REPO_ROOT}/scripts/deploy/set_env.sh

PCL_CODE_ID=$(jq -r '.astroport_pair_concentrated' "${REPO_ROOT}/contract_addresses.json")
XYK_CODE_ID=$(jq -r '.astroport_pair' "${REPO_ROOT}/contract_addresses.json")
COIN_REGISTRY_ADDRESS=$(jq -r '.astroport_coin_registry_address' "${REPO_ROOT}/contract_addresses.json")



params='"init_params": {
      "owner": "'$(babylond keys show $userKey -a)'",
      "pair_configs": [
        {
          "code_id": "'$PCL_CODE_ID'",
          "pair_type": { "concentrated": {} },
          "total_fee_bps": "100",
          "maker_fee_bps": "50",
          "is_disabled": false,
          "is_generator_disabled": false,
          "permissioned": true
        },
        {
          "code_id": "'$XYK_CODE_ID'",
          "pair_type": { "xyk": {} },
          "total_fee_bps": "100",
          "maker_fee_bps": "10",
          "is_disabled": false,
          "is_generator_disabled": false,
          "permissioned": true
        }
      ],
      "token_code_id": "1",
      "fee_address": null,
      "incentives_address": null,
      "coin_registry_address": "'$COIN_REGISTRY_ADDRESS'"
    }'

bash ${REPO_ROOT}/scripts/deploy/instantiate.sh "astroport_native_coin_registry" "$params"