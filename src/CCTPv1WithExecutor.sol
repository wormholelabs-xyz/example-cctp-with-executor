// SPDX-License-Identifier: Apache 2
pragma solidity ^0.8.19;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

import "example-messaging-executor/evm/src/interfaces/IExecutor.sol";
import "example-messaging-executor/evm/src/libraries/ExecutorMessages.sol";

import {ICircleV1TokenMessenger} from "./interfaces/circle/ICircleV1TokenMessenger.sol";
import {IMessageTransmitter} from "./interfaces/circle/IMessageTransmitter.sol";

import "./interfaces/ICCTPv1WithExecutor.sol";

string constant cctpWithExecutorVersion = "CCTPv1WithExecutor-0.0.1";

/// @title CCTPv1WithExecutor
/// @author Executor Project Contributors.
/// @notice The CCTPv1WithExecutor contract is a shim contract that initiates a Circle transfer using the executor for relaying.
contract CCTPv1WithExecutor is ICCTPv1WithExecutor {
    ICircleV1TokenMessenger public immutable circleTokenMessenger;
    IExecutor public immutable executor;
    uint32 public immutable sourceDomain;

    string public constant VERSION = cctpWithExecutorVersion;

    constructor(address _circleTokenMessenger, address _executor) {
        assert(_circleTokenMessenger != address(0));
        assert(_executor != address(0));
        circleTokenMessenger = ICircleV1TokenMessenger(_circleTokenMessenger);
        executor = IExecutor(_executor);

        // The source domain is the local domain on the Message Transmitter contract.
        sourceDomain = IMessageTransmitter(circleTokenMessenger.localMessageTransmitter()).localDomain();
    }

    // ==================== External Interface ===============================================

    /// @inheritdoc ICCTPv1WithExecutor
    function depositForBurn(
        uint256 amount,
        uint16 destinationChain,
        uint32 destinationDomain,
        bytes32 mintRecipient,
        address burnToken,
        ExecutorArgs calldata executorArgs
    ) external payable returns (uint64 nonce) {
        // Custody the tokens in this contract.
        amount = custodyTokens(burnToken, amount);
        SafeERC20.safeApprove(IERC20(burnToken), address(circleTokenMessenger), amount);

        // Initiate the transfer.
        nonce = circleTokenMessenger.depositForBurn(amount, destinationDomain, mintRecipient, burnToken);

        // Generate the executor event.
        executor.requestExecution{value: msg.value}(
            destinationChain,
            bytes32(0), // The executor will derive this. It is the Circle message transmitter on the destination domain.
            executorArgs.refundAddress,
            executorArgs.signedQuote,
            ExecutorMessages.makeCCTPv1Request(sourceDomain, nonce),
            executorArgs.instructions
        );

        // Refund any excess value back to the caller.
        // TODO: Not sure this is right.
        uint256 currentBalance = address(this).balance;
        if (currentBalance > 0) {
            (bool refundSuccessful,) = payable(msg.sender).call{value: currentBalance}("");
            if (!refundSuccessful) {
                revert RefundFailed(currentBalance);
            }
        }
    }

    // necessary for receiving native assets
    receive() external payable {}

    // ==================== Internal Functions ==============================================

    function custodyTokens(address token, uint256 amount) internal returns (uint256) {
        // query own token balance before transfer
        uint256 balanceBefore = getBalance(token);

        // deposit tokens
        SafeERC20.safeTransferFrom(IERC20(token), msg.sender, address(this), amount);

        // return the balance difference
        return getBalance(token) - balanceBefore;
    }

    function getBalance(address token) internal view returns (uint256 balance) {
        // fetch the specified token balance for this contract
        (, bytes memory queriedBalance) =
            token.staticcall(abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)));
        balance = abi.decode(queriedBalance, (uint256));
    }
}
