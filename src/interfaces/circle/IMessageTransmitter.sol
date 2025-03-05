// SPDX-License-Identifier: Apache 2
pragma solidity ^0.8.19;

///@dev This only includes what is needed by the CCTPWithExecutor contract.
interface IMessageTransmitter {
    function localDomain() external view returns (uint32);
}
