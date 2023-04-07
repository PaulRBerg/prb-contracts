// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { ERC20_Test } from "../ERC20.t.sol";

contract BalanceOf_Test is ERC20_Test {
    /// @dev it should return zero.
    function test_BalanceOf_DoesNotHaveBalance(address foo) external {
        uint256 actualBalance = dai.balanceOf(foo);
        uint256 expectedBalance = 0;
        assertEq(actualBalance, expectedBalance, "balance");
    }

    modifier whenBalanceNonZero() {
        _;
    }

    /// @dev it should return the correct balance.
    function testFuzz_BalanceOf(address foo, uint256 amount) external whenBalanceNonZero {
        vm.assume(foo != address(0));
        amount = bound(amount, 1, ONE_MILLION_DAI);

        // Mint `amount` tokens to `foo`.
        dai.mint({ beneficiary: foo, amount: amount });

        // Run the test.
        uint256 actualBalance = dai.balanceOf(foo);
        uint256 expectedBalance = amount;
        assertEq(actualBalance, expectedBalance, "balance");
    }
}
