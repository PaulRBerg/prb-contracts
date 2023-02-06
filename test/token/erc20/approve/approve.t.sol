// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { stdError } from "forge-std/StdError.sol";

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20_Test } from "../ERC20.t.sol";

contract Approve_Test is ERC20_Test {
    /// @dev it should revert.
    function test_RevertWhen_OwnerZeroAddress() external {
        // Make the zero address the caller in this test.
        changePrank(address(0));

        // Run the test.
        vm.expectRevert(IERC20.ERC20_ApproveOwnerZeroAddress.selector);
        dai.approve({ spender: users.alice, value: ONE_MILLION_DAI });
    }

    modifier ownerNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_SpenderZeroAddress() external ownerNotZeroAddress {
        vm.expectRevert(IERC20.ERC20_ApproveSpenderZeroAddress.selector);
        dai.approve({ spender: address(0), value: ONE_MILLION_DAI });
    }

    modifier spenderNotZeroAddress() {
        _;
    }

    /// @dev it should make the approval.
    function testFuzz_Approve(address spender, uint256 amount) external ownerNotZeroAddress spenderNotZeroAddress {
        vm.assume(spender != address(0));
        dai.approve(spender, amount);
        uint256 actualAllowance = dai.allowance({ owner: users.alice, spender: spender });
        uint256 expectedAllowance = amount;
        assertEq(actualAllowance, expectedAllowance, "allowance");
    }

    /// @dev it should emit an Approval event.
    function testFuzz_Approve_Event(address spender, uint256 amount)
        external
        ownerNotZeroAddress
        spenderNotZeroAddress
    {
        vm.assume(spender != address(0));
        vm.expectEmit({ checkTopic1: true, checkTopic2: true, checkTopic3: false, checkData: true });
        emit Approval({ owner: users.alice, spender: spender, amount: amount });
        dai.approve(spender, amount);
    }
}
