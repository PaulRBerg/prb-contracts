// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20Recover_Test } from "../ERC20Recover.t.sol";

contract GetTokenDenylist_Test is ERC20Recover_Test {
    /// @dev it should return an empty array.
    function test_GetTokenDenylist_TokenDenylistNotSet() external {
        IERC20[] memory actualTokenDenylist = erc20Recover.getTokenDenylist();
        IERC20[] memory expectedTokenDenylist;
        assertEq(actualTokenDenylist, expectedTokenDenylist, "tokenDenylist");
    }

    /// @dev it should return an empty array.
    function test_GetTokenDenylist_EmptyArray() external {
        IERC20[] memory tokenDenylist;
        erc20Recover.setTokenDenylist(tokenDenylist);

        IERC20[] memory actualTokenDenylist = erc20Recover.getTokenDenylist();
        IERC20[] memory expectedTokenDenylist;
        assertEq(actualTokenDenylist, expectedTokenDenylist, "tokenDenylist");
    }

    /// @dev it should return the token denylist.
    function test_GetTokenDenylist_NonEmptyArray() external {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
        IERC20[] memory actualTokenDenylist = erc20Recover.getTokenDenylist();
        IERC20[] memory expectedTokenDenylist = TOKEN_DENYLIST;
        assertEq(actualTokenDenylist, expectedTokenDenylist, "tokenDenylist");
    }
}
