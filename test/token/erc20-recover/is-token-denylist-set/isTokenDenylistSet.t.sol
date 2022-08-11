// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20RecoverTest } from "../ERC20RecoverTest.t.sol";

contract ERC20Recover__IsTokenDenylistSet is ERC20RecoverTest {
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
