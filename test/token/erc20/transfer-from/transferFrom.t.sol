// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { stdError } from "forge-std/Test.sol";

import { ERC20Test } from "../ERC20Test.t.sol";

contract ERC20__TransferFrom is ERC20Test {
    /// @dev it should revert.
    function testCannotTransferFrom__SpenderAllowanceNotEnough(address owner, uint256 amount) external {
        vm.assume(owner != address(0));
        vm.assume(amount > 0);

        address spender = users.alice;
        uint256 currentAllowance = 0;
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20.ERC20__InsufficientAllowance.selector,
                owner,
                spender,
                currentAllowance,
                amount
            )
        );
        dai.transferFrom(owner, spender, amount);
    }

    modifier SpenderAllowanceEnough() {
        _;
    }

    /// @dev it should transfer the tokens.
    function testTransferFrom(
        address owner,
        address to,
        uint256 amount0,
        uint256 amount1
    ) external SpenderAllowanceEnough {
        vm.assume(owner != address(0));
        vm.assume(to != address(0));
        vm.assume(owner != to);
        vm.assume(amount0 > 0);
        vm.assume(amount1 > 0);
        vm.assume(amount1 <= amount0);

        // Mint `amount` tokens to the owner.
        dai.mint(owner, amount0);

        // Approve Alice to spend tokens from the owner.
        address spender = users.alice;
        changePrank(owner);
        dai.approve(spender, amount0);

        // Run the test.
        changePrank(spender);
        uint256 previousOwnerBalance = dai.balanceOf(owner);
        uint256 previousToBalance = dai.balanceOf(to);
        dai.transferFrom(owner, to, amount1);

        uint256 actualOwnerBalance = dai.balanceOf(owner);
        uint256 actualToBalance = dai.balanceOf(to);
        uint256 expectedOwnerBalance = previousOwnerBalance - amount1;
        uint256 expectedToBalance = previousToBalance + amount1;

        assertEq(actualOwnerBalance, expectedOwnerBalance);
        assertEq(actualToBalance, expectedToBalance);
    }

    /// @dev it should emit an Approval and a Transfer event.
    function testTransferFrom__Event(
        address owner,
        address to,
        uint256 amount0,
        uint256 amount1
    ) external SpenderAllowanceEnough {
        vm.assume(owner != address(0));
        vm.assume(to != address(0));
        vm.assume(owner != to);
        vm.assume(amount0 > 0);
        vm.assume(amount1 > 0);
        vm.assume(amount1 <= amount0);

        // Mint `amount0` tokens to the owner.
        dai.mint(owner, amount0);

        // Approve Alice to spend tokens from the owner.
        address spender = users.alice;
        changePrank(owner);
        dai.approve(spender, amount0);

        // Run the test.
        changePrank(spender);
        vm.expectEmit(true, true, false, true);
        emit Approval(owner, spender, amount0 - amount1);
        vm.expectEmit(true, true, false, true);
        emit Transfer(owner, to, amount1);
        dai.transferFrom(owner, to, amount1);
    }
}
