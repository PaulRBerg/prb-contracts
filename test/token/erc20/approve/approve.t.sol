// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { stdError } from "forge-std/Test.sol";

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20Test } from "../ERC20.t.sol";

contract Approve_Test is ERC20Test {
    /// @dev it should revert.
    function test_RevertWhen_OwnerZeroAddress() external {
        // Make the zero address the caller in this test.
        changePrank(address(0));

        // Run the test.
        vm.expectRevert(IERC20.ERC20_ApproveOwnerZeroAddress.selector);
        dai.approve(users.alice, ONE_MILLION_DAI);
    }

    modifier OwnerNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_SpenderZeroAddress() external OwnerNotZeroAddress {
        address spender = address(0);
        vm.expectRevert(IERC20.ERC20_ApproveSpenderZeroAddress.selector);
        dai.approve(spender, ONE_MILLION_DAI);
    }

    modifier SpenderNotZeroAddress() {
        _;
    }

    /// @dev it should make the approval.
    function testFuzz_Approve(address spender, uint256 value) external OwnerNotZeroAddress SpenderNotZeroAddress {
        vm.assume(spender != address(0));
        dai.approve(spender, value);
        uint256 actualAllowance = dai.allowance(users.alice, spender);
        uint256 expectedAllowance = value;
        assertEq(actualAllowance, expectedAllowance);
    }

    /// @dev it should emit an Approval event.
    function testFuzz_Approve_Event(address spender, uint256 value) external OwnerNotZeroAddress SpenderNotZeroAddress {
        vm.assume(spender != address(0));
        vm.expectEmit({ checkTopic1: true, checkTopic2: true, checkTopic3: false, checkData: true });
        emit Approval(users.alice, spender, value);
        dai.approve(spender, value);
    }
}
