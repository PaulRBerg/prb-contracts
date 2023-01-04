// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { stdError } from "forge-std/Test.sol";

import { ERC20Test } from "../ERC20.t.sol";

contract ERC20__IncreaseAllowance is ERC20Test {
    /// @dev it should revert.
    function testCannotIncreaseAllowance__CalculationOverflowsUint256(
        address spender,
        uint256 amount0,
        uint256 amount1
    ) external {
        vm.assume(spender != address(0));
        vm.assume(amount0 > 0);
        vm.assume(amount1 > MAX_UINT256 - amount0);

        dai.increaseAllowance(spender, amount0);
        vm.expectRevert(stdError.arithmeticError);
        dai.increaseAllowance(spender, amount1);
    }

    modifier CalculationDoesNotOverflowUint256() {
        _;
    }

    /// @dev it should increase the allowance.
    function testIncreaseAllowance(address spender, uint256 value) external CalculationDoesNotOverflowUint256 {
        vm.assume(spender != address(0));

        dai.increaseAllowance(spender, value);
        uint256 actualAllowance = dai.allowance(users.alice, spender);
        uint256 expectedAllowance = value;
        assertEq(actualAllowance, expectedAllowance);
    }

    /// @dev it should emit an Approval event.
    function testIncreaseAllowance__Event(address spender, uint256 value) external CalculationDoesNotOverflowUint256 {
        vm.assume(spender != address(0));
        vm.assume(value > 0);

        vm.expectEmit(true, true, false, true);
        emit Approval(users.alice, spender, value);
        dai.increaseAllowance(spender, value);
    }
}
