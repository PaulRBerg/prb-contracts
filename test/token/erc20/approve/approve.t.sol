// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { stdError } from "forge-std/StdError.sol";

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20_Test } from "../ERC20.t.sol";

contract Approve_Test is ERC20_Test {
    function test_RevertWhen_OwnerZeroAddress() external {
        // Make the zero address the caller in this test.
        changePrank(address(0));

        // Run the test.
        vm.expectRevert(IERC20.ERC20_ApproveOwnerZeroAddress.selector);
        dai.approve({ spender: users.alice, value: ONE_MILLION_DAI });
    }

    modifier whenOwnerNotZeroAddress() {
        _;
    }

    function test_RevertWhen_SpenderZeroAddress() external whenOwnerNotZeroAddress {
        vm.expectRevert(IERC20.ERC20_ApproveSpenderZeroAddress.selector);
        dai.approve({ spender: address(0), value: ONE_MILLION_DAI });
    }

    modifier whenSpenderNotZeroAddress() {
        _;
    }

    function testFuzz_Approve(
        address spender,
        uint256 amount
    )
        external
        whenOwnerNotZeroAddress
        whenSpenderNotZeroAddress
    {
        vm.assume(spender != address(0));
        dai.approve(spender, amount);
        uint256 actualAllowance = dai.allowance({ owner: users.alice, spender: spender });
        uint256 expectedAllowance = amount;
        assertEq(actualAllowance, expectedAllowance, "allowance");
    }

    function testFuzz_Approve_Event(
        address spender,
        uint256 amount
    )
        external
        whenOwnerNotZeroAddress
        whenSpenderNotZeroAddress
    {
        vm.assume(spender != address(0));
        vm.expectEmit();
        emit Approval({ owner: users.alice, spender: spender, amount: amount });
        dai.approve(spender, amount);
    }
}
