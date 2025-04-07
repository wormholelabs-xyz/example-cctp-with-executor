// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

import {CCTPv1WithExecutor, cctpWithExecutorVersion} from "../src/CCTPv1WithExecutor.sol";
import "forge-std/Script.sol";

// DeployCCTPv1WithExecutor is a forge script to deploy the CCTPv1WithExecutor contract. Use ./sh/deployCCTPv1WithExecutor.sh to invoke this.
//    EVM_CHAIN_ID= MNEMONIC= CIRCLE_TOKEN_MESSENGER_ADDR= ./sh/deployCCTPv1WithExecutor.sh
contract DeployCCTPv1WithExecutor is Script {
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
        CCTPv1WithExecutor cctpWithExecutor = new CCTPv1WithExecutor{salt: salt}(circleTokenMessenger, executor);

        return (address(cctpWithExecutor));
    }
}
