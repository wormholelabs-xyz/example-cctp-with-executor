// SPDX-License-Identifier: Apache 2
pragma solidity >=0.8.8 <0.9.0;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Upgrade.sol";

import "example-messaging-executor/evm/src/Executor.sol";

import "../src/CCTPv1WithExecutor.sol";
import "../src/interfaces/ICCTPv1WithExecutor.sol";
import "../src/interfaces/circle/ICircleV1TokenMessenger.sol";
import "../src/interfaces/circle/IMessageTransmitter.sol";

contract MockToken is ERC20, ERC1967Upgrade {
    constructor() ERC20("MockToken", "DTKN") {}

    // NOTE: this is purposefully not called mint() to so we can test that in
    // locking mode the NttManager contract doesn't call mint (or burn)
    function mintDummy(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function mint(address, uint256) public virtual {
        revert("Locking nttManager should not call 'mint()'");
    }

    function burnFrom(address, uint256) public virtual {
        revert("No nttManager should call 'burnFrom()'");
    }

    function burn(address, uint256) public virtual {
        revert("Locking nttManager should not call 'burn()'");
    }

    function upgrade(address newImplementation) public {
        _upgradeTo(newImplementation);
    }
}

contract MockExecutor is Executor {
    constructor(uint16 _chainId) Executor(_chainId) {}

    function chainId() public view returns (uint16) {
        return ourChain;
    }

    // NOTE: This was copied from the tests in the executor repo.
    function encodeSignedQuoteHeader(Executor.SignedQuoteHeader memory signedQuote)
        public
        pure
        returns (bytes memory)
    {
        return abi.encodePacked(
            signedQuote.prefix,
            signedQuote.quoterAddress,
            signedQuote.payeeAddress,
            signedQuote.srcChain,
            signedQuote.dstChain,
            signedQuote.expiryTime
        );
    }

    function createSignedQuote(uint16 dstChain) public view returns (bytes memory) {
        return createSignedQuote(dstChain, 60);
    }

    function createSignedQuote(uint16 dstChain, uint64 quoteLife) public view returns (bytes memory) {
        Executor.SignedQuoteHeader memory signedQuote = IExecutor.SignedQuoteHeader({
            prefix: "EQ01",
            quoterAddress: address(0),
            payeeAddress: bytes32(0),
            srcChain: ourChain,
            dstChain: dstChain,
            expiryTime: uint64(block.timestamp + quoteLife)
        });
        return encodeSignedQuoteHeader(signedQuote);
    }

    function createExecutorInstructions() public pure returns (bytes memory) {
        return new bytes(0);
    }

    function createArgs(uint16 dstChain) public view returns (ExecutorArgs memory args) {
        args.refundAddress = msg.sender;
        args.signedQuote = createSignedQuote(dstChain);
        args.instructions = createExecutorInstructions();
    }

    function msgValue() public pure returns (uint256) {
        return 0;
    }
}

contract MockCircleTokenMessenger {
    IMessageTransmitter public immutable messageTransmitter;
    uint64 public nonce;

    constructor(address _messageTransmitter) {
        messageTransmitter = IMessageTransmitter(_messageTransmitter);
    }

    function depositForBurn(uint256, uint32, bytes32, address) external returns (uint64 _nonce) {
        _nonce = nonce++;
    }

    function localMessageTransmitter() external view returns (IMessageTransmitter) {
        return messageTransmitter;
    }
}

contract MockMessageTransmitter is IMessageTransmitter {
    uint32 public immutable sourceDomain;

    constructor(uint32 _sourceDomain) {
        sourceDomain = _sourceDomain;
    }

    function localDomain() external view returns (uint32) {
        return sourceDomain;
    }
}

contract MockCCTPv1WithExecutor is CCTPv1WithExecutor {
    constructor(address _circleTokenMessenger, address _executor)
        CCTPv1WithExecutor(_circleTokenMessenger, _executor)
    {}
}

contract TestCCTPv1WithExecutor is Test {
    MockExecutor executor;
    MockMessageTransmitter circleMessageTransmitter;
    MockCircleTokenMessenger circleTokenMessenger;
    CCTPv1WithExecutor cctpWithExecutor;

    uint16 constant chainId = 7;
    uint16 constant chainId2 = 8;

    uint32 constant destinationDomain = 3;

    address user_A = address(0x123);
    address user_B = address(0x456);
    address referrer = address(0x789);

    function setUp() public {
        executor = new MockExecutor(chainId);
        circleMessageTransmitter = new MockMessageTransmitter(2);
        circleTokenMessenger = new MockCircleTokenMessenger(address(circleMessageTransmitter));
        cctpWithExecutor = new CCTPv1WithExecutor(address(circleTokenMessenger), address(executor));

        string memory url = "https://ethereum-sepolia-rpc.publicnode.com";
        vm.createSelectFork(url);

        // Give everyone some money to play with.
        vm.deal(user_A, 1 ether);
        vm.deal(user_B, 1 ether);
        vm.deal(referrer, 1 ether);
    }

    function test_setUp() public view {
        assertEq(2, cctpWithExecutor.sourceDomain());
    }

    function test_depositForBurnWithExecutor() public {
        MockToken token = new MockToken();
        uint8 decimals = token.decimals();
        uint256 transferTokenFee = 1;
        uint256 nativeTokenFee = 2;
        token.mintDummy(address(user_A), 5 * 10 ** decimals);

        vm.startPrank(user_A);
        token.approve(address(cctpWithExecutor), 1 * 10 ** decimals + transferTokenFee);

        uint256 startingBalance = token.balanceOf(address(user_A));
        uint256 cctpStartingBalance = address(cctpWithExecutor).balance;
        uint256 amount = 1 * 10 ** decimals;
        uint256 expectedTokenFee = transferTokenFee;
        uint256 expectedNativeFee = address(referrer).balance + nativeTokenFee;

        ExecutorArgs memory executorArgs = executor.createArgs(chainId2);
        FeeArgs memory feeArgs =
            FeeArgs({transferTokenFee: transferTokenFee, nativeTokenFee: nativeTokenFee, payee: referrer});
        uint64 nonce1 = cctpWithExecutor.depositForBurn{value: 100}(
            amount,
            chainId2,
            destinationDomain,
            bytes32(uint256(uint160(address(user_B)))),
            address(token),
            executorArgs,
            feeArgs
        );

        assertEq(nonce1, 0);

        uint256 endingBalance = token.balanceOf(address(user_A));
        assertEq(endingBalance, startingBalance - amount - transferTokenFee);
        uint256 cctpEndingBalance = address(cctpWithExecutor).balance;
        assertEq(cctpEndingBalance, cctpStartingBalance);
        assertEq(expectedTokenFee, token.balanceOf(referrer));
        assertEq(expectedNativeFee, address(referrer).balance);
    }

    function test_depositForBurnWithExecutorWithNoFee() public {
        MockToken token = new MockToken();
        uint8 decimals = token.decimals();
        token.mintDummy(address(user_A), 5 * 10 ** decimals);

        vm.startPrank(user_A);
        token.approve(address(cctpWithExecutor), 1 * 10 ** decimals);

        uint256 startingBalance = token.balanceOf(address(user_A));
        uint256 cctpStartingBalance = address(cctpWithExecutor).balance;
        uint256 amount = 1 * 10 ** decimals;

        ExecutorArgs memory executorArgs = executor.createArgs(chainId2);
        FeeArgs memory feeArgs = FeeArgs({transferTokenFee: 0, nativeTokenFee: 0, payee: address(0)});
        uint64 nonce1 = cctpWithExecutor.depositForBurn{value: 100}(
            amount,
            chainId2,
            destinationDomain,
            bytes32(uint256(uint160(address(user_B)))),
            address(token),
            executorArgs,
            feeArgs
        );

        assertEq(nonce1, 0);

        uint256 endingBalance = token.balanceOf(address(user_A));
        assertEq(endingBalance, startingBalance - amount);
        uint256 cctpEndingBalance = address(cctpWithExecutor).balance;
        assertEq(cctpEndingBalance, cctpStartingBalance);
    }
}
