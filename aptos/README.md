# Aptos

The cctp_v1_with_executor folder was generated with `aptos move init --name cctp_v1_with_executor`.

This module was developed with aptos CLI `7.2.0`.

While an [Aptos script](https://aptos.dev/en/build/smart-contracts/book/modules-and-scripts) could have been used, a pre-deployed module seemed an easier approach for integration and matches the EVM implementation.

## Development

[Move IDE Plugins](https://aptos.dev/en/build/smart-contracts#move-ide-plugins)

### Compile

Ensure the `aptos-cctp` has been pulled.

```bash
cd aptos/cctp_v1_with_executor
git submodule init --recursive  -- lib/aptos-cctp
```

If its submodules could not be cloned, modify `lib/aptos-cctp/.gitmodules` and replace `git@github.com:` with `https://github.com/`. Then,

```bash
git submodule sync --recursive
git submodule init --recursive  -- lib/aptos-cctp
```

Add `--skip-fetch-latest-git-deps` to skip fetching the dependencies again.

#### Dev

```bash
aptos move compile --dev --named-addresses cctp_v1_with_executor=default,executor=0x139717c339f08af674be77143507a905aa28cbc67a0e53e7095c07b630d73815,executor_requests=0xf6cc46a85f8cac9852c62904f09ec7fc9d3fe41ff646913853bed2a992c1d6d7
```

#### Testnet

Addresses from [Circle docs](https://developers.circle.com/stablecoins/aptos-packages) and [Executor Addresses](https://wormholelabs.notion.site/Executor-Addresses-Public-1f93029e88cb80df940eeb8867a01081)

```bash
aptos move compile --skip-fetch-latest-git-deps --named-addresses cctp_v1_with_executor=default,executor=0x139717c339f08af674be77143507a905aa28cbc67a0e53e7095c07b630d73815,executor_requests=0xf6cc46a85f8cac9852c62904f09ec7fc9d3fe41ff646913853bed2a992c1d6d7,message_transmitter=0x081e86cebf457a0c6004f35bd648a2794698f52e0dde09a48619dcd3d4cc23d9,token_messenger_minter=0x5f9b937419dda90aa06c1836b7847f65bbbe3f1217567758dc2488be31a477b9,stablecoin=0x72d1e6aa6a648a3afc5d45d8d66b353f1e1837a728c0813beec77f28a697fa7a,aptos_extensions=0xb75a74c6f8fddb93fdc00194e2295d8d5c3f6a721e79a2b86884394dcc554f8f,deployer=default
```

#### Mainnet

Addresses from [Circle docs](https://developers.circle.com/stablecoins/aptos-packages) and [Executor Addresses](https://wormholelabs.notion.site/Executor-Addresses-Public-1f93029e88cb80df940eeb8867a01081)

```bash
aptos move compile --skip-fetch-latest-git-deps --named-addresses cctp_v1_with_executor=default,executor=0x11aa75c059e1a7855be66b931bf340a2e0973274ac16b5f519c02ceafaf08a18,executor_requests=0x589f326a8fd5a0b28b25d829713dcf999407d52c2af99cb56fc074b809160d77,message_transmitter=0x177e17751820e4b4371873ca8c30279be63bdea63b88ed0f2239c2eea10f1772,token_messenger_minter=0x9bce6734f7b63e835108e3bd8c36743d4709fe435f44791918801d0989640a9d,stablecoin=0xe5c5befe31ce06bc1f2fd31210988aac08af6d821b039935557a6f14c03471be,aptos_extensions=0x98bce69c31ee2cf91ac50a3f38db7b422e3df7cdde9fe672ee1d03538a6aeae0,deployer=default
```

### Deploy

First initialize the config, setting the desired network and deployment private key.

```bash
cd cctp_v1_with_executor
aptos init
```

Then, publish the module immutably via a resource account.

#### Testnet

```bash
aptos move create-resource-account-and-publish-package --address-name cctp_v1_with_executor --seed-encoding Utf8 --seed cctp_v1_with_executor_v0 --named-addresses executor=0x139717c339f08af674be77143507a905aa28cbc67a0e53e7095c07b630d73815,executor_requests=0xf6cc46a85f8cac9852c62904f09ec7fc9d3fe41ff646913853bed2a992c1d6d7,message_transmitter=0x081e86cebf457a0c6004f35bd648a2794698f52e0dde09a48619dcd3d4cc23d9,token_messenger_minter=0x5f9b937419dda90aa06c1836b7847f65bbbe3f1217567758dc2488be31a477b9,stablecoin=0x72d1e6aa6a648a3afc5d45d8d66b353f1e1837a728c0813beec77f28a697fa7a,aptos_extensions=0xb75a74c6f8fddb93fdc00194e2295d8d5c3f6a721e79a2b86884394dcc554f8f,deployer=default
```

#### Mainnet

```bash
aptos move create-resource-account-and-publish-package --address-name cctp_v1_with_executor --seed-encoding Utf8 --seed cctp_v1_with_executor_v0 --named-addresses executor=0x11aa75c059e1a7855be66b931bf340a2e0973274ac16b5f519c02ceafaf08a18,executor_requests=0x589f326a8fd5a0b28b25d829713dcf999407d52c2af99cb56fc074b809160d77,message_transmitter=0x177e17751820e4b4371873ca8c30279be63bdea63b88ed0f2239c2eea10f1772,token_messenger_minter=0x9bce6734f7b63e835108e3bd8c36743d4709fe435f44791918801d0989640a9d,stablecoin=0xe5c5befe31ce06bc1f2fd31210988aac08af6d821b039935557a6f14c03471be,aptos_extensions=0x98bce69c31ee2cf91ac50a3f38db7b422e3df7cdde9fe672ee1d03538a6aeae0,deployer=default
```
