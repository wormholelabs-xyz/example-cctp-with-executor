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

Addresses from [Circle docs](https://developers.circle.com/stablecoins/aptos-packages) and [Executor repo](https://github.com/wormholelabs-xyz/example-messaging-executor/blob/aptos/aptos/DEPLOYMENTS.md)

```bash
aptos move compile --skip-fetch-latest-git-deps --named-addresses cctp_v1_with_executor=default,executor=0x139717c339f08af674be77143507a905aa28cbc67a0e53e7095c07b630d73815,executor_requests=0xf6cc46a85f8cac9852c62904f09ec7fc9d3fe41ff646913853bed2a992c1d6d7,message_transmitter=0x081e86cebf457a0c6004f35bd648a2794698f52e0dde09a48619dcd3d4cc23d9,token_messenger_minter=0x5f9b937419dda90aa06c1836b7847f65bbbe3f1217567758dc2488be31a477b9,stablecoin=0x72d1e6aa6a648a3afc5d45d8d66b353f1e1837a728c0813beec77f28a697fa7a,aptos_extensions=0xb75a74c6f8fddb93fdc00194e2295d8d5c3f6a721e79a2b86884394dcc554f8f,deployer=default
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
