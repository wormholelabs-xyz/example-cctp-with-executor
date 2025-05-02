# CCTPv1WithExecutor EVM Deployments

## Testnet

### April 23, 2025

This version fixes a possible overflow in the fee calculation.

#### Version Info

Commit Hash:

<!-- cspell:disable -->

```sh
example-ntt-with-executor (main)$ git rev-parse HEAD
8fb6ced234b09e58e7fda0f738a1595e9fbf94c7
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

- Sepolia (10002): [0x0F78904c750801391EbBf308181e9d6fc892B0f3](https://sepolia.etherscan.io/address/0x0F78904c750801391EbBf308181e9d6fc892B0f3)
- Base Sepolia (10004): [0x4983C6bD3bB7DA9EECe71cfa7AE4C67CAbf362F0](https://sepolia.basescan.org/address/0x4983C6bD3bB7DA9EECe71cfa7AE4C67CAbf362F0)
- Avalanche Fuji (6): [0x2cfEC91B50f657Cc86Ec693542527ac3e03bF742](https://testnet.snowtrace.io/address/0x2cfEC91B50f657Cc86Ec693542527ac3e03bF742)

### DEPRECATED: April 16, 2025

This version adds support for paying a fee to the referrer.

#### Version Info

Commit Hash:

<!-- cspell:disable -->

```sh
example-ntt-with-executor (main)$ git rev-parse HEAD
633b050f8e18f4c9717c5a86a1ccb69758189cee
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

- Sepolia (10002): [0x4Cbf94024Ff07a7cd69d687084d67773Fc6ef925](https://sepolia.etherscan.io/address/0x4Cbf94024Ff07a7cd69d687084d67773Fc6ef925)
- Base Sepolia (10004): [0x17166DEC8502769eBD6D30112098a4588eA2e88A](https://sepolia.basescan.org/address/0x17166DEC8502769eBD6D30112098a4588eA2e88A)
- Avalanche Fuji (6): [0x0254356716c59a3DA3C0e19EFf58511ba7f0002F](https://testnet.snowtrace.io/address/0x0254356716c59a3DA3C0e19EFf58511ba7f0002F)

### DEPRECATED: April 7, 2025

#### Version Info

Commit Hash:

<!-- cspell:disable -->

```sh
example-ntt-with-executor (main)$ git rev-parse HEAD
bdaed7ef9975c37b1e1fde48b983d23333373e6e
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

- Sepolia (10002): [0x57861330Ff78dB78E95dD792306E52286C444302](https://sepolia.etherscan.io/address/0x57861330Ff78dB78E95dD792306E52286C444302)
- Base Sepolia (10004): [0xC280F102d2D7EC1390A456700F3471a883059F42](https://sepolia.basescan.org/address/0xC280F102d2D7EC1390A456700F3471a883059F42)
- Avalanche Fuji (6): [0x5C91b5dcd7DCd6a04cc2290e0420A8644402C7CC](https://testnet.snowtrace.io/address/0x5C91b5dcd7DCd6a04cc2290e0420A8644402C7CC)

### Bytecode Verification

If you wish to verify that the bytecode built locally matches what is deployed on chain, you can do something like this:

<!-- cspell:disable -->

```
forge verify-bytecode <contract_addr> CCTPv1WithExecutor --rpc-url <archive_node_rpc> --verifier-api-key <your_etherscan_key>
```

<!-- cspell:enable -->

# CCTPv2WithExecutor EVM Deployments

## Testnet

### May 2, 2025

This is the initial deployment.

#### Version Info

Commit Hash:

<!-- cspell:disable -->

```sh
example-cctp-with-executor (main)$ git rev-parse HEAD
d46c585dba875708b65210a6fbce8471d9466126
example-cctp-with-executor (main)$

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

- Sepolia (10002): [0x0F18DD26D0B41fb1eaa9cF34D1Ec6022aA69a8e2](https://sepolia.etherscan.io/address/0x0F18DD26D0B41fb1eaa9cF34D1Ec6022aA69a8e2)
- Base Sepolia (10004): [0xC400FcC0e92d3406747FBb6f513D3aa8B038fcE9](https://sepolia.basescan.org/address/0xC400FcC0e92d3406747FBb6f513D3aa8B038fcE9)
- Avalanche Fuji (6): [0x4058F0C3924eDaB19c15597C438968ed49C1a213](https://testnet.snowtrace.io/address/0x4058F0C3924eDaB19c15597C438968ed49C1a213)
