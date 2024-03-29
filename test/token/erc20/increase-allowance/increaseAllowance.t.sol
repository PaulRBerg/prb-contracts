// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { stdError } from "forge-std/StdError.sol";

import { ERC20_Test } from "../ERC20.t.sol";

contract IncreaseAllowance_Test is ERC20_Test {
    function test_RevertWhen_CalculationOverflowsUint256(address spender, uint256 amount0, uint256 amount1) external {
        vm.assume(spender != address(0));
        vm.assume(amount0 > 0);
        amount1 = _bound(amount1, MAX_UINT256 - amount0 + 1, MAX_UINT256);

        // Increase the allowance.
        dai.increaseAllowance(spender, amount0);

        // Expect an arithmetic error.
        vm.expectRevert(stdError.arithmeticError);

        // Increase the allowance again.
        dai.increaseAllowance(spender, amount1);
    }

    modifier whenCalculationDoesNotOverflowUint256() {
        _;
    }

    function testFuzz_IncreaseAllowance(
        address spender,
        uint256 value
    )
        external
        whenCalculationDoesNotOverflowUint256
    {
        vm.assume(spender != address(0));

        // Increase the allowance.
        dai.increaseAllowance(spender, value);

        // Assert that the allowance has been increased.
        uint256 actualAllowance = dai.allowance(users.alice, spender);
        uint256 expectedAllowance = value;
        assertEq(actualAllowance, expectedAllowance, "allowance");
    }

    function testFuzz_IncreaseAllowance_Event(
        address spender,
        uint256 value
    )
        external
        whenCalculationDoesNotOverflowUint256
    {
        vm.assume(spender != address(0));
        vm.assume(value > 0);

        // Expect an {Approval} event to be emitted.
        vm.expectEmit({ emitter: address(dai) });
        emit Approval(users.alice, spender, value);

        // Increase the allowance.
        dai.increaseAllowance(spender, value);
    }
}
