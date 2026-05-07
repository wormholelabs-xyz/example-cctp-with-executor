// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.19;

import {CCTPv1WithExecutor, cctpWithExecutorVersion} from "../src/CCTPv1WithExecutor/v1/CCTPv1WithExecutor.sol";
import "forge-std/Script.sol";

// DeployCCTPv1WithExecutorV1 deploys CCTPv1WithExecutor contract version 0.0.1.
// Use ./sh/deployCCTPv1WithExecutorV1.sh to invoke this.
contract DeployCCTPv1WithExecutorV1 is Script {
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
