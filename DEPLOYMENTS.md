# CCTPv1WithExecutor EVM Deployments

## Testnet

### April 16, 2025

This version adds support for paying a fee to the referrer.

#### Version Info

Commit Hash:

<!-- cspell:disable -->

```sh
example-ntt-with-executor (main)$ git rev-parse HEAD
5114e800ba35231ab2a10332bb8a2df954756c66
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
