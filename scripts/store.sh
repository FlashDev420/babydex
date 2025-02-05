#!/bin/bash
set -eo pipefail

# deploys a given wasm artifact to the babylon env

# Check if artifact name is provided
if [ -z "$1" ]; then
    echo "Error: Artifact name is required"
    echo "Usage: $0 <artifact-name>"
    exit 1
fi

artifact="$1"

for cmd in babylond jq git; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: $cmd is required but not installed."
        exit 1
    fi
done

REPO_ROOT=$(git rev-parse --show-toplevel)

source ${REPO_ROOT}/scripts/set_env.sh

cd ${REPO_ROOT}/artifacts

# Ensure artifact has .wasm extension for storage
artifact_path="$artifact"
if [[ ! "$artifact" =~ \.wasm$ ]]; then
    artifact_path="${artifact}.wasm"
fi

echo "Storing $(basename "$artifact_path")..."
res=$(babylond tx wasm store "$artifact_path" $keyringBackend --from $userKey --chain-id $chainId --gas 5000000 --gas-prices 0.01$feeToken --node $nodeUrl -y -b sync -o "json")
echo $res
txhash=$(echo "$res" | jq -r '.txhash')
echo "Transaction hash: $txhash"
sleep 45
code_id=$(babylond q tx $txhash -o json --node $nodeUrl | jq -r '.events[] | select(.type == "store_code").attributes[] | select(.key == "code_id").value')
echo "Code ID: $code_id"

json_file="${REPO_ROOT}/scripts/code_ids.json"

if [ ! -f "$json_file" ]; then
    echo "{}" > "$json_file"
fi

# Set the code id in the json file
filename=$(basename "$artifact")
filename="${filename%.wasm}"  # Remove .wasm extension if it exists
jq --arg name "$filename" --arg id "$code_id" \
    '. + {($name): $id}' "$json_file" > "$json_file.tmp" && mv "$json_file.tmp" "$json_file"