// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { console2 } from "forge-std/console2.sol";
import { stdError } from "forge-std/Test.sol";

import { ERC20UnitTest } from "../ERC20UnitTest.t.sol";

contract ERC20__Transfer is ERC20UnitTest {
    /// @dev it should revert.
    function testCannotTransfer__SenderZeroAddress() external {
        // Make the zero address the caller in this test.
        changePrank(address(0));

        // Run the test.
        vm.expectRevert(IERC20.ERC20__TransferFromZeroAddress.selector);
        dai.transfer(users.alice, ONE_MILLION_DAI);
    }

    modifier SenderNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testCannotTransfer__RecipientZeroAddress() external SenderNotZeroAddress {
        vm.expectRevert(IERC20.ERC20__TransferToZeroAddress.selector);
        address to = address(0);
        dai.transfer(to, ONE_MILLION_DAI);
    }

    modifier RecipientNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testCannotTransfer__SenderNotEnoughBalance(uint256 amount)
        external
        SenderNotZeroAddress
        RecipientNotZeroAddress
    {
        vm.assume(amount > 0);

        uint256 senderBalance = 0;
        vm.expectRevert(abi.encodeWithSelector(IERC20.ERC20__FromInsufficientBalance.selector, senderBalance, amount));
        dai.transfer(users.alice, amount);
    }

    modifier SenderEnoughBalance() {
        _;
    }

    /// @dev it should transfer the tokens.
    function testTransfer__RecipientSender(uint256 amount)
        external
        SenderNotZeroAddress
        RecipientNotZeroAddress
        SenderEnoughBalance
    {
        vm.assume(amount > 0);

        // Mint `amount` tokens to Alice so that we have something to transfer below.
        dai.mint(users.alice, amount);

        // Run the test.
        uint256 expectedBalance = dai.balanceOf(users.alice);
        dai.transfer(users.alice, amount);
        uint256 actualBalance = dai.balanceOf(users.alice);
        assertEq(actualBalance, expectedBalance);
    }

    /// @dev it should transfer the tokens.
    function testTransfer__RecipientNotSender(address to, uint256 amount)
        external
        SenderNotZeroAddress
        RecipientNotZeroAddress
        SenderEnoughBalance
    {
        vm.assume(to != address(0));
        vm.assume(to != users.alice);
        vm.assume(amount > 0);

        // Mint `amount` tokens to Alice so that we have something to transfer below.
        dai.mint(users.alice, amount);

        // Run the test.
        uint256 previousBalance = dai.balanceOf(to);
        dai.transfer(to, amount);
        uint256 actualBalance = dai.balanceOf(to);
        uint256 expectedBalance = previousBalance + amount;
        assertEq(actualBalance, expectedBalance);
    }

    /// @dev it should emit a Transfer event.
    function testTransfer__RecipientNotSender__Event(address to, uint256 amount)
        external
        SenderNotZeroAddress
        RecipientNotZeroAddress
        SenderEnoughBalance
    {
        vm.assume(to != address(0));
        vm.assume(to != users.alice);
        vm.assume(amount > 0);

        // Mint `amount` tokens to Alice so that we have something to transfer below.
        dai.mint(users.alice, amount);

        // Run the test.
        vm.expectEmit(true, true, false, true);
        emit Transfer(users.alice, to, amount);
        dai.transfer(to, amount);
    }
}
