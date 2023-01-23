// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { ERC20Test } from "../ERC20.t.sol";

contract BalanceOf_Test is ERC20Test {
    /// @dev it should return zero.
    function test_BalanceOf_DoesNotHaveBalance(address foo) external {
        uint256 actualBalance = dai.balanceOf(foo);
        uint256 expectedBalance = 0;
        assertEq(actualBalance, expectedBalance, "balance");
    }

    /// @dev it should return the correct balance.
    function testFuzz_BalanceOf_HasBalance(address foo, uint256 amount) external {
        vm.assume(foo != address(0));
        vm.assume(amount < ONE_MILLION_DAI);

        // Mint `amount` tokens to `foo`.
        dai.mint(foo, amount);

        // Run the test.
        uint256 actualBalance = dai.balanceOf(foo);
        uint256 expectedBalance = amount;
        assertEq(actualBalance, expectedBalance, "balance");
    }
}
