// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { ERC20Recover_Test } from "../ERC20Recover.t.sol";

contract IsTokenDenylistSet_Test is ERC20Recover_Test {
    function test_IsTokenDenylistSet_TokenDenylistNotSet() external {
        bool isTokenDenylistSet = erc20Recover.isTokenDenylistSet();
        assertFalse(isTokenDenylistSet, "isTokenDenylistSet");
    }

    function test_IsTokenDenylistSet_TokenDenylistSet() external {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
        bool isTokenDenylistSet = erc20Recover.isTokenDenylistSet();
        assertTrue(isTokenDenylistSet, "isTokenDenylistSet");
    }
}
