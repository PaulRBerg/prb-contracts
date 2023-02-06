// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { stdError } from "forge-std/StdError.sol";

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20_Test } from "../ERC20.t.sol";

contract Transfer_Test is ERC20_Test {
    /// @dev it should revert.
    function test_RevertWhen_SenderZeroAddress() external {
        // Make the zero address the caller in this test.
        changePrank(address(0));

        // Run the test.
        vm.expectRevert(IERC20.ERC20_TransferFromZeroAddress.selector);
        dai.transfer({ to: users.alice, amount: ONE_MILLION_DAI });
    }

    modifier senderNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_ReceiverZeroAddress() external senderNotZeroAddress {
        vm.expectRevert(IERC20.ERC20_TransferToZeroAddress.selector);
        dai.transfer({ to: address(0), amount: ONE_MILLION_DAI });
    }

    modifier recipientNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testFuzz_RevertWhen_SenderNotEnoughBalance(uint256 amount)
        external
        senderNotZeroAddress
        recipientNotZeroAddress
    {
        vm.assume(amount > 0);

        uint256 senderBalance = 0;
        vm.expectRevert(abi.encodeWithSelector(IERC20.ERC20_FromInsufficientBalance.selector, senderBalance, amount));
        dai.transfer(users.alice, amount);
    }

    modifier enderEnoughBalance() {
        _;
    }

    /// @dev it should transfer the tokens.
    function testFuzz_Transfer_ReceiverSender(uint256 amount)
        external
        senderNotZeroAddress
        recipientNotZeroAddress
        enderEnoughBalance
    {
        vm.assume(amount > 0);

        // Mint `amount` tokens to Alice so that we have something to transfer below.
        dai.mint({ beneficiary: users.alice, amount: amount });

        // Load the initial balance.
        uint256 initialBalance = dai.balanceOf(users.alice);

        // Transfer the tokens.
        dai.transfer(users.alice, amount);

        // Assert that the user's balance has remained unchanged.
        uint256 actualBalance = dai.balanceOf(users.alice);
        uint256 expectedBalance = initialBalance;
        assertEq(actualBalance, expectedBalance, "balance");
    }

    /// @dev Checks common assumptions for the tests below.
    function checkAssumptions(address to, uint256 amount) internal view {
        vm.assume(to != address(0));
        vm.assume(to != users.alice);
        vm.assume(amount > 0);
    }

    /// @dev it should transfer the tokens.
    function testFuzz_Transfer_ReceiverNotSender_DecreaseSenderBalance(address to, uint256 amount)
        external
        senderNotZeroAddress
        recipientNotZeroAddress
        enderEnoughBalance
    {
        checkAssumptions(to, amount);

        // Mint `amount` tokens to Alice so that we have something to transfer below.
        dai.mint(users.alice, amount);

        // Run the test.
        uint256 initialBalance = dai.balanceOf(users.alice);

        // Transfer the tokens.
        dai.transfer(to, amount);

        // Assert that the sender's balance has decreased.
        uint256 actualBalance = dai.balanceOf(users.alice);
        uint256 expectedBalance = initialBalance - amount;
        assertEq(actualBalance, expectedBalance, "balance");
    }

    /// @dev it should transfer the tokens.
    function testFuzz_Transfer_ReceiverNotSender_IncreaseReceiverBalance(address to, uint256 amount)
        external
        senderNotZeroAddress
        recipientNotZeroAddress
        enderEnoughBalance
    {
        checkAssumptions(to, amount);

        // Mint `amount` tokens to Alice so that we have something to transfer below.
        dai.mint(users.alice, amount);

        // Run the test.
        uint256 initialBalance = dai.balanceOf(to);

        // Transfer the tokens.
        dai.transfer(to, amount);

        // Assert that the receiver's balance has increased.
        uint256 actualBalance = dai.balanceOf(to);
        uint256 expectedBalance = initialBalance + amount;
        assertEq(actualBalance, expectedBalance, "balance");
    }

    /// @dev it should emit a Transfer event.
    function testFuzz_Transfer_ReceiverNotSender_Event(address to, uint256 amount)
        external
        senderNotZeroAddress
        recipientNotZeroAddress
        enderEnoughBalance
    {
        checkAssumptions(to, amount);

        // Mint `amount` tokens to Alice so that we have something to transfer below.
        dai.mint(users.alice, amount);

        // Expect a {Transfer} event to be emitted.
        vm.expectEmit({ checkTopic1: true, checkTopic2: true, checkTopic3: false, checkData: true });
        emit Transfer(users.alice, to, amount);

        // Transfer the tokens.
        dai.transfer(to, amount);
    }
}
