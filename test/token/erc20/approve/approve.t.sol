// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { stdError } from "forge-std/Test.sol";

import { ERC20Test } from "../ERC20Test.t.sol";

contract ERC20__Approve is ERC20Test {
    /// @dev it should revert.
    function testCannotApprove__OwnerZeroAddress() external {
        // Make the zero address the caller in this test.
        changePrank(address(0));

        // Run the test.
        vm.expectRevert(IERC20.ERC20__ApproveOwnerZeroAddress.selector);
        dai.approve(users.alice, ONE_MILLION_DAI);
    }

    modifier OwnerNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testCannotApprove__SpenderZeroAddress() external OwnerNotZeroAddress {
        address spender = address(0);
        vm.expectRevert(IERC20.ERC20__ApproveSpenderZeroAddress.selector);
        dai.approve(spender, ONE_MILLION_DAI);
    }

    modifier SpenderNotZeroAddress() {
        _;
    }

    /// @dev it should make the approval.
    function testApprove(address spender, uint256 value) external OwnerNotZeroAddress SpenderNotZeroAddress {
        vm.assume(spender != address(0));

        dai.approve(spender, value);
        uint256 actualAllowance = dai.allowance(users.alice, spender);
        uint256 expectedAllowance = value;
        assertEq(actualAllowance, expectedAllowance);
    }

    /// @dev it should emit an Approval event.
    function testApprove__Event(address spender, uint256 value) external OwnerNotZeroAddress SpenderNotZeroAddress {
        vm.assume(spender != address(0));

        vm.expectEmit(true, true, false, true);
        emit Approval(users.alice, spender, value);
        dai.approve(spender, value);
    }
}
