# CCTPv1WithExecutor EVM Deployments

## Testnet

### April 2, 2025

#### Version Info

Commit Hash:

<!-- cspell:disable -->

```sh
example-ntt-with-executor (main)$ git rev-parse HEAD
84cf1b9ea9fa0adbd824a13a1c4884ab56d8c397
example-ntt-with-executor (main)$
```

<!-- cspell:enable -->

Foundry Version:

<!-- cspell:disable -->

```sh
evm (main)$ forge --version
forge Version: 1.0.0-stable
Commit SHA: e144b82070619b6e10485c38734b4d4d45aebe04
Build Timestamp: 2025-02-13T20:03:31.026474817Z (1739477011)
Build Profile: maxperf
evm (main)$
```

<!-- cspell:enable -->

#### Chains Deployed

Here are the deployed contract addresses for each chain. The number after the chain name is the Wormhole chain ID configured for the contract.

- Sepolia (10002): [0xD0864BE4021A6E6674d21d2E4412E9B9e7df370a](https://sepolia.etherscan.io/address/0xD0864BE4021A6E6674d21d2E4412E9B9e7df370a)
- Base Sepolia (10004): [0xeb944540F4bA0612492AB8D9fEa35a348D523bAB](https://sepolia.basescan.org/address/0xeb944540F4bA0612492AB8D9fEa35a348D523bAB)
- Avalanche Fuji (6): [0x7845106A3394A9CDfd9E464de2b78F12e897E1B9](https://testnet.snowtrace.io/address/0x7845106A3394A9CDfd9E464de2b78F12e897E1B9)

### Bytecode Verification

If you wish to verify that the bytecode built locally matches what is deployed on chain, you can do something like this:

<!-- cspell:disable -->

```
forge verify-bytecode <contract_addr> CCTPv1WithExecutor --rpc-url <archive_node_rpc> --verifier-api-key <your_etherscan_key>
```

<!-- cspell:enable -->
