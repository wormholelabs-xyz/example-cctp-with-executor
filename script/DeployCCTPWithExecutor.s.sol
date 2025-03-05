// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

import {CCTPWithExecutor, cctpWithExecutorVersion} from "../src/CCTPWithExecutor.sol";
import "forge-std/Script.sol";

// DeployCCTPWithExecutor is a forge script to deploy the CCTPWithExecutor contract. Use ./sh/deployCCTPWithExecutor.sh to invoke this.
//    EVM_CHAIN_ID= MNEMONIC= CIRCLE_TOKEN_MESSENGER_ADDR= ./sh/deployCCTPWithExecutor.sh
contract DeployCCTPWithExecutor is Script {
    function test() public {} // Exclude this from coverage report.

    function dryRun(address circleTokenMessenger, address executor) public {
        _deploy(circleTokenMessenger, executor);
    }

    function run(address circleTokenMessenger, address executor) public returns (address deployedAddress) {
        vm.startBroadcast();
        (deployedAddress) = _deploy(circleTokenMessenger, executor);
        vm.stopBroadcast();
    }

    function _deploy(address circleTokenMessenger, address executor) internal returns (address deployedAddress) {
        bytes32 salt = keccak256(abi.encodePacked(cctpWithExecutorVersion));
        CCTPWithExecutor cctpWithExecutor = new CCTPWithExecutor{salt: salt}(circleTokenMessenger, executor);

        return (address(cctpWithExecutor));
    }
}
