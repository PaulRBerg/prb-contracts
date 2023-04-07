// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { stdError } from "forge-std/StdError.sol";

import { ERC20_Test } from "../ERC20.t.sol";

contract DecreaseAllowance_Test is ERC20_Test {
    function test_RevertWhen_CalculationUnderflowsUint256(address spender, uint256 value) external {
        vm.assume(spender != address(0));
        vm.assume(value > 0);

        // Expect an arithmetic error.
        vm.expectRevert(stdError.arithmeticError);

        // Decrease the allowance.
        dai.decreaseAllowance(spender, value);
    }

    modifier whenCalculationDoesNotUnderflowUint256() {
        _;
    }

    /// @dev Check common assumptions for the tests below.
    function checkAssumptions(address spender, uint256 value0) internal pure {
        vm.assume(spender != address(0));
        vm.assume(value0 > 0);
    }

    function testFuzz_DecreaseAllowance(
        address spender,
        uint256 value0,
        uint256 value1
    )
        external
        whenCalculationDoesNotUnderflowUint256
    {
        checkAssumptions(spender, value0);
        value1 = bound(value1, 0, value0);

        // Increase the allowance so that we have what to decrease below.
        dai.increaseAllowance(spender, value0);

        // Decrease the allowance.
        dai.decreaseAllowance(spender, value1);

        // Assert that the allowance has been decreased.
        uint256 actualAllowance = dai.allowance(users.alice, spender);
        uint256 expectedAllowance = value0 - value1;
        assertEq(actualAllowance, expectedAllowance, "allowance");
    }

    function testFuzz_DecreaseAllowance_Event(
        address spender,
        uint256 value0,
        uint256 value1
    )
        external
        whenCalculationDoesNotUnderflowUint256
    {
        checkAssumptions(spender, value0);
        value1 = bound(value1, 0, value0);

        // Increase the allowance so that we have what to decrease below.
        dai.increaseAllowance(spender, value0);

        // Expect an {Approval} event to be emitted.
        vm.expectEmit({ emitter: address(dai) });
        uint256 expectedAllowance = value0 - value1;
        emit Approval(users.alice, spender, expectedAllowance);

        // Decrease the allowance.
        dai.decreaseAllowance(spender, value1);
    }
}
