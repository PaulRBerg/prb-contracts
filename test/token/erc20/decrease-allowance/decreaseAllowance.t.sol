// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { stdError } from "forge-std/Test.sol";

import { ERC20Test } from "../ERC20.t.sol";

contract DecreaseAllowance_Test is ERC20Test {
    /// @dev it should revert.
    function test_RevertWhen_CalculationUnderflowsUint256(address spender, uint256 value) external {
        vm.assume(spender != address(0));
        vm.assume(value > 0);

        vm.expectRevert(stdError.arithmeticError);
        dai.decreaseAllowance(spender, value);
    }

    modifier calculationDoesNotUnderflowUint256() {
        _;
    }

    /// @dev Check common assumptions for the tests below.
    function checkAssumptions(
        address spender,
        uint256 value0,
        uint256 value1
    ) internal pure {
        vm.assume(spender != address(0));
        vm.assume(value0 > 0);
        vm.assume(value1 <= value0);
    }

    /// @dev it should decrease the allowance.
    function testFuzz_DecreaseAllowance(
        address spender,
        uint256 value0,
        uint256 value1
    ) external calculationDoesNotUnderflowUint256 {
        checkAssumptions(spender, value0, value1);

        // Increase the allowance so that we have what to decrease below.
        dai.increaseAllowance(spender, value0);

        // Run the test.
        dai.decreaseAllowance(spender, value1);
        uint256 actualAllowance = dai.allowance(users.alice, spender);
        uint256 expectedAllowance = value0 - value1;
        assertEq(actualAllowance, expectedAllowance);
    }

    /// @dev it should emit an Approval event.
    function testFuzz_DecreaseAllowance_Event(
        address spender,
        uint256 value0,
        uint256 value1
    ) external calculationDoesNotUnderflowUint256 {
        checkAssumptions(spender, value0, value1);

        // Increase the allowance so that we have what to decrease below.
        dai.increaseAllowance(spender, value0);

        // Run the test.
        vm.expectEmit({ checkTopic1: true, checkTopic2: true, checkTopic3: false, checkData: true });
        uint256 expectedAllowance = value0 - value1;
        emit Approval(users.alice, spender, expectedAllowance);
        dai.decreaseAllowance(spender, value1);
    }
}
