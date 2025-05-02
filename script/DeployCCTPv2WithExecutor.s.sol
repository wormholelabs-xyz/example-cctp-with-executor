// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

import {CCTPv2WithExecutor, cctpWithExecutorVersion} from "../src/CCTPv2WithExecutor.sol";
import "forge-std/Script.sol";

// DeployCCTPv2WithExecutor is a forge script to deploy the CCTPv2WithExecutor contract. Use ./sh/deployCCTPv2WithExecutor.sh to invoke this.
contract DeployCCTPv2WithExecutor is Script {
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
        CCTPv2WithExecutor cctpWithExecutor = new CCTPv2WithExecutor{salt: salt}(circleTokenMessenger, executor);

        return (address(cctpWithExecutor));
    }
}
