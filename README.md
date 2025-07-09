# Example CCTP With Executor

This repo contains Aptos and EVM helper contracts for bundling a [CCTP](https://developers.circle.com/cctp) transfer with an [Executor](https://github.com/wormholelabs-xyz/example-messaging-executor) request for execution in a single transaction.

For the SVM (Solana) contract, see https://github.com/wormholelabs-xyz/example-cctp-with-executor-svm

Deployments can be found at https://wormholelabs.notion.site/Executor-Addresses-Public-1f93029e88cb80df940eeb8867a0108

⚠ **This software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied. See the License for the specific language governing permissions and limitations under the License.** Or plainly
spoken - this is a very complex piece of software which targets a bleeding-edge, experimental smart contract runtime.
Mistakes happen, and no matter how hard you try and whether you pay someone to audit it, it may eat your tokens, set
your printer on fire or startle your cat. Cryptocurrencies are a high-risk investment, no matter how fancy.

## Aptos

See [aptos/README.md](./aptos/README.md)

## EVM

### CCTP Version 1 With Executor Shim

This contract provides the ability to invoke a CCTP version 1 `depositForBurn` and request that the executor relay the attestation to the destination domain.

#### Simple Test Case

It is possible to invoke this contract using the `cast` command. This example does a `depositForBurn` of USDC **from Sepolia to Base Sepolia**.

**NOTE**: To use this example, you need the URL for the Executor Quote Server. See the executor docs for details.

##### Approve the contract to spend the tokens

First you need to approve the contract to spend some tokens. You can do this in the explorer by going to the
[USDC ERC20 contract](https://sepolia.etherscan.io/address/0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238#writeProxyContract), connecting your wallet and approving the contract
(0xD0864BE4021A6E6674d21d2E4412E9B9e7df370a) to spend the desired value. This example assumes a value of one.

##### Generate the Executor parameters

Next you need to generate the executor parameters for a transfer from Sepolia (10002) to Base Sepolia (1004) as follows. Note that quotes expire, so don't generate them too far in advance.

<!-- cspell:disable -->

```
$ curl -X 'POST' \
  '$EXECUTOR_URL/v0/quote' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "srcChain": 10002,
  "dstChain": 10004,
  "relayInstructions": "0x0100000000000000000000000000030d4000000000000000000000000000000000"
}'
{"signedQuote":"0x455130315241c9276698439fef2780dbab76fec90b633fbd000000000000000000000000f7122c001b3e07d7fafd8be3670545135859954a271227140000000067eed9f800000000000003e800000000000f43ce00001029131756000000102913175600f4f48d1f6fe650c82294f5b96c673a60f3aee00d030e55b2f0f760640cc0c65a362e911671dcb1c4cd0476015a259b5828a2c40cd7ddfae3cb22a27cc4753be31c","estimatedCost":"300079600000"}
```

<!-- cspell:enable -->

##### Set environment variables

This example assumes the following environment variables.

- $PRIV_KEY is your wallet private key.
- $PUB_KEY is your wallet public key.
- $PUB_KEY_AS_B32 is your wallet key converted to a bytes32, like "0x000000000000000000000000XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX".
- $USDC is the appropriate contract address from [here](https://developers.circle.com/stablecoins/usdc-on-test-networks), in our case it is `0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238`.
- $AMOUNT is 1 in this example.
- $DST_CHAIN is 10004 in this example.
- $DST_DOMAIN is from [here](https://developers.circle.com/stablecoins/evm-smart-contracts), in this example it is 6.
- $VALUE is the `estimatedCost` from above.
- $SIGNED_QUOTE is the `signedQuote` from above.
- $INST is the `relayInstructions` from above.

##### Use the cast command to initiate the transfer

Finally, you can use a cast command like this to invoke the contract to do the `depostForBurn`.

<!-- cspell:disable -->

```
cast send --value $VALUE 0xD0864BE4021A6E6674d21d2E4412E9B9e7df370a --private-key $PRIV_KEY --rpc-url https://ethereum-sepolia-rpc.publicnode.com "depositForBurn(uint256,uint16,uint32,bytes32,address,(address,bytes,bytes))" $AMOUNT $DST_CHAIN $DST_DOMAIN $PUB_KEY_AS_B32 $USDC "($PUB_KEY,$SIGNED_QUOTE,$INST)"
```

<!-- cspell:enable -->

### CCTP Version 2 With Executor Shim

This contract provides the ability to invoke a CCTP version 2 `depositForBurn` and request that the executor relay the attestation to the destination domain.
