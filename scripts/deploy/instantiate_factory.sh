#!/bin/bash
set -eo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
source ${REPO_ROOT}/scripts/deploy/set_env.sh

PCL_CODE_ID=$(jq -r '.astroport_pair_concentrated' "${REPO_ROOT}/scripts/deploy/code_ids.json")
XYK_CODE_ID=$(jq -r '.astroport_pair' "${REPO_ROOT}/scripts/deploy/code_ids.json")
CW20_CODE_ID=$(jq -r '.cw20_base' "${REPO_ROOT}/scripts/deploy/code_ids.json")

COIN_REGISTRY_ADDRESS=$(jq -r '.astroport_native_coin_registry' "${REPO_ROOT}/scripts/deploy/contract_addresses.json")
OWNER=$(babylond keys show $userKey -a)


params='{
            "pair_configs": [
                {
                    "code_id": 82,
                    "pair_type": { "concentrated": {}},
                    "total_fee_bps": 100,
                    "maker_fee_bps": 50,
                    "is_disabled": false,
                    "is_generator_disabled": false,
                    "permissioned": true
                },
                {
                    "code_id": 83,
                    "pair_type": {"xyk": {}},
                    "total_fee_bps": 100,
                    "maker_fee_bps": 10,
                    "is_disabled": false,
                    "is_generator_disabled": false,
                    "permissioned": true
                }
            ],
            "token_code_id": 99,
            "owner": "bbn1knv468atwzjk4v0d22jwa497v0sd0zez3lh7g3",
            "fee_address": "bbn1knv468atwzjk4v0d22jwa497v0sd0zez3lh7g3",
            "incentives_address": null,
            "coin_registry_address": "'$COIN_REGISTRY_ADDRESS'"
        }'

echo $params

bash ${REPO_ROOT}/scripts/deploy/instantiate.sh "astroport_factory" "$params"