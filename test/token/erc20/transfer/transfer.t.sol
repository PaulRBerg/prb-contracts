// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { console2 } from "forge-std/console2.sol";
import { stdError } from "forge-std/Test.sol";

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20Test } from "../ERC20.t.sol";

contract Transfer_Test is ERC20Test {
    /// @dev it should revert.
    function test_RevertWhen_SenderZeroAddress() external {
        // Make the zero address the caller in this test.
        changePrank(address(0));

        // Run the test.
        vm.expectRevert(IERC20.ERC20_TransferFromZeroAddress.selector);
        dai.transfer(users.alice, ONE_MILLION_DAI);
    }

    modifier senderNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_RecipientZeroAddress() external senderNotZeroAddress {
        vm.expectRevert(IERC20.ERC20_TransferToZeroAddress.selector);
        address to = address(0);
        dai.transfer(to, ONE_MILLION_DAI);
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
    function testFuzz_Transfer_RecipientSender(uint256 amount)
        external
        senderNotZeroAddress
        recipientNotZeroAddress
        enderEnoughBalance
    {
        vm.assume(amount > 0);

        // Mint `amount` tokens to Alice so that we have something to transfer below.
        dai.mint(users.alice, amount);

        // Run the test.
        uint256 expectedBalance = dai.balanceOf(users.alice);
        dai.transfer(users.alice, amount);
        uint256 actualBalance = dai.balanceOf(users.alice);
        assertEq(actualBalance, expectedBalance, "balance");
    }

    /// @dev Checks common assumptions for the tests below.
    function checkAssumptions(address to, uint256 amount) internal view {
        vm.assume(to != address(0));
        vm.assume(to != users.alice);
        vm.assume(amount > 0);
    }

    /// @dev it should transfer the tokens.
    function testFuzz_Transfer_RecipientNotSender(address to, uint256 amount)
        external
        senderNotZeroAddress
        recipientNotZeroAddress
        enderEnoughBalance
    {
        checkAssumptions(to, amount);

        // Mint `amount` tokens to Alice so that we have something to transfer below.
        dai.mint(users.alice, amount);

        // Run the test.
        uint256 previousBalance = dai.balanceOf(to);
        dai.transfer(to, amount);
        uint256 actualBalance = dai.balanceOf(to);
        uint256 expectedBalance = previousBalance + amount;
        assertEq(actualBalance, expectedBalance, "balance");
    }

    /// @dev it should emit a Transfer event.
    function testFuzz_Transfer_RecipientNotSender_Event(address to, uint256 amount)
        external
        senderNotZeroAddress
        recipientNotZeroAddress
        enderEnoughBalance
    {
        checkAssumptions(to, amount);

        // Mint `amount` tokens to Alice so that we have something to transfer below.
        dai.mint(users.alice, amount);

        // Run the test.
        vm.expectEmit({ checkTopic1: true, checkTopic2: true, checkTopic3: false, checkData: true });
        emit Transfer(users.alice, to, amount);
        dai.transfer(to, amount);
    }
}
