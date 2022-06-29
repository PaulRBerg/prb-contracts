// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20RecoverUnitTest } from "../ERC20RecoverUnitTest.t.sol";

contract ERC20Recover__IsTokenDenylistSet is ERC20RecoverUnitTest {
    /// @dev it should return false.
    function testIsTokenDenylistSet__TokenDenylistNotSet() external {
        bool isTokenDenylistSet = erc20Recover.isTokenDenylistSet();
        assertEq(isTokenDenylistSet, false);
    }

    /// @dev it should return true.
    function testIsTokenDenylistSet__TokenDenylistSet() external {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
        bool isTokenDenylistSet = erc20Recover.isTokenDenylistSet();
        assertEq(isTokenDenylistSet, true);
    }
}
