#!/bin/bash

#
# This script deploys the CCTPWithExecutor contract.
# Usage: RPC_URL= MNEMONIC= EVM_CHAIN_ID= OUR_CHAIN_ID= EXECUTOR= ./sh/deployCCTPWithExecutor.sh
#    EVM_CHAIN_ID= MNEMONIC= CIRCLE_TOKEN_MESSENGER_ADDR= ./sh/deployCCTPWithExecutor.sh

[[ -z $CIRCLE_TOKEN_MESSENGER_ADDR ]] && { echo "Missing Circle Token Messenger address"; exit 1; }
[[ -z $EXECUTOR ]] && { echo "Missing EXECUTOR"; exit 1; }

if [ "${RPC_URL}X" == "X" ]; then
  RPC_URL=http://localhost:8545
fi

if [ "${MNEMONIC}X" == "X" ]; then
  MNEMONIC=0x4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d
fi

if [ "${EVM_CHAIN_ID}X" == "X" ]; then
  EVM_CHAIN_ID=1337
fi

forge script ./script/DeployCCTPWithExecutor.s.sol:DeployCCTPWithExecutor \
	--sig "run(address,address)" $CIRCLE_TOKEN_MESSENGER_ADDR $EXECUTOR \
	--rpc-url "$RPC_URL" \
	--private-key "$MNEMONIC" \
	--broadcast ${FORGE_ARGS}

returnInfo=$(cat ./broadcast/DeployCCTPWithExecutor.s.sol/$EVM_CHAIN_ID/run-latest.json)

DEPLOYED_ADDRESS=$(jq -r '.returns.deployedAddress.value' <<< "$returnInfo")
echo "Deployed CCTP with executor address: $DEPLOYED_ADDRESS"
