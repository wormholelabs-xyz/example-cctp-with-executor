// SPDX-License-Identifier: Apache 2
pragma solidity ^0.8.19;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

import "example-messaging-executor/evm/src/interfaces/IExecutor.sol";
import "example-messaging-executor/evm/src/libraries/ExecutorMessages.sol";

import {ICircleV2TokenMessenger} from "./interfaces/circle/ICircleV2TokenMessenger.sol";
import {IMessageTransmitter} from "./interfaces/circle/IMessageTransmitter.sol";

import "./interfaces/ICCTPv2WithExecutor.sol";

string constant cctpWithExecutorVersion = "CCTPv2WithExecutor-0.0.1";

/// @title CCTPv2WithExecutor
/// @author Executor Project Contributors.
/// @notice The CCTPv2WithExecutor contract is a shim contract that initiates a Circle transfer using the executor for relaying.
contract CCTPv2WithExecutor is ICCTPv2WithExecutor {
    ICircleV2TokenMessenger public immutable circleTokenMessenger;
    IExecutor public immutable executor;
    uint32 public immutable sourceDomain;

    string public constant VERSION = cctpWithExecutorVersion;

    constructor(address _circleTokenMessenger, address _executor) {
        assert(_circleTokenMessenger != address(0));
        assert(_executor != address(0));
        circleTokenMessenger = ICircleV2TokenMessenger(_circleTokenMessenger);
        executor = IExecutor(_executor);

        // The source domain is the local domain on the Message Transmitter contract.
        sourceDomain = IMessageTransmitter(circleTokenMessenger.localMessageTransmitter()).localDomain();
    }

    // ==================== External Interface ===============================================

    /// @inheritdoc ICCTPv2WithExecutor
    function depositForBurn(
        uint256 amount,
        uint16 destinationChain,
        uint32 destinationDomain,
        bytes32 mintRecipient,
        address burnToken,
        bytes32 destinationCaller,
        uint256 maxFee,
        uint32 minFinalityThreshold,
        ExecutorArgs calldata executorArgs,
        FeeArgs calldata feeArgs
    ) external payable {
        // Custody the tokens in this contract.
        amount = custodyTokens(burnToken, amount);

        // Transfer the fee to the referrer.
        amount = payFee(burnToken, amount, feeArgs);

        // Initiate the transfer.
        SafeERC20.safeIncreaseAllowance(IERC20(burnToken), address(circleTokenMessenger), amount);
        circleTokenMessenger.depositForBurn(
            amount, destinationDomain, mintRecipient, burnToken, destinationCaller, maxFee, minFinalityThreshold
        );

        // Generate the executor event.
        executor.requestExecution{value: msg.value}(
            destinationChain,
            bytes32(0), // The executor will derive this. It is the Circle message transmitter on the destination domain.
            executorArgs.refundAddress,
            executorArgs.signedQuote,
            ExecutorMessages.makeCCTPv2Request(),
            executorArgs.instructions
        );
    }

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

    // @dev The fee is calculated as a percentage of the amount being transferred.
    function payFee(address token, uint256 amount, FeeArgs calldata feeArgs) internal returns (uint256) {
        uint256 fee = calculateFee(amount, feeArgs.dbps);
        if (fee > 0) {
            // Don't need to check for fee greater than or equal to amount because it can never be (since dbps is a uint16).
            amount -= fee;
            SafeERC20.safeTransfer(IERC20(token), feeArgs.payee, fee);
        }
        return amount;
    }

    function calculateFee(uint256 amount, uint16 dbps) public pure returns (uint256 fee) {
        unchecked {
            uint256 q = amount / 100000;
            uint256 r = amount % 100000;
            fee = q * dbps + (r * dbps) / 100000;
        }
    }
}
