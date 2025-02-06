# Deploying the contracts
## Storing contracts
call `bash scripts/store.sh WASM-CONTRACT.wasm` to store a specific contract. The code id is automatically updated in code_ids.json


## Instantiating contract
`instantiate.sh` instantiates a single contract for an arbitrary json. The correct code id is fetched from code_ids.json by the script. This script needs to caller to match an instantiate message to the code id.