export binary="babylond"
export chainId="bbn-test-5"
export homeDir="$HOME/.babylond"

export userKey="user"
export keyringBackend="--keyring-backend=test"
export feeToken="ubbn"

export rpcUrl="https://babylon-testnet-rpc.nodes.guru"
export nodeUrl="$rpcUrl"
export grpcUrl="https://babylon-testnet-grpc.nodes.guru"
export address=$(babylond --home $homeDir keys show $userKey -a)

alias babylond='babylond --home $homeDir'