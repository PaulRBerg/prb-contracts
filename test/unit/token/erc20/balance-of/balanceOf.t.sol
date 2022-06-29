// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20UnitTest } from "../ERC20UnitTest.t.sol";

contract ERC20__BalanceOf__DoesNotHaveBalance is ERC20UnitTest {
    /// @dev it should return zero.
    function testBalanceOf(address foo) external {
        uint256 actualBalance = dai.balanceOf(foo);
        uint256 expectedBalance = 0;
        assertEq(actualBalance, expectedBalance);
    }
}

contract HasBalance {}

contract ERC20__BalanceOf is ERC20UnitTest, HasBalance {
    /// @dev it should return the correct balance.
    function testBalanceOf(address foo, uint256 amount) external {
        vm.assume(foo != address(0));
        vm.assume(amount < ONE_MILLION_DAI);

        // Mint `amount` tokens to `foo`.
        dai.mint(foo, amount);

        // Run the test.
        uint256 actualBalance = dai.balanceOf(foo);
        uint256 expectedBalance = amount;
        assertEq(actualBalance, expectedBalance);
    }
}
