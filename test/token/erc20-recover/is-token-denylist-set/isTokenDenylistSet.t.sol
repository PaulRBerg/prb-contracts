// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { ERC20RecoverTest } from "../ERC20Recover.t.sol";

contract IsTokenDenylistSet_Test is ERC20RecoverTest {
    /// @dev it should return false.
    function test_IsTokenDenylistSet_TokenDenylistNotSet() external {
        bool isTokenDenylistSet = erc20Recover.isTokenDenylistSet();
        assertEq(isTokenDenylistSet, false);
    }

    /// @dev it should return true.
    function test_IsTokenDenylistSet_TokenDenylistSet() external {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
        bool isTokenDenylistSet = erc20Recover.isTokenDenylistSet();
        assertEq(isTokenDenylistSet, true);
    }
}
