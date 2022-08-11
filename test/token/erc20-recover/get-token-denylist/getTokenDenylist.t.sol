// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { ERC20RecoverTest } from "../ERC20RecoverTest.t.sol";

contract ERC20Recover__GetTokenDenylist is ERC20RecoverTest {
    /// @dev it should return an empty array.
    function testGetTokenDenylist__TokenDenylistNotSet() external {
        IERC20[] memory actualTokenDenylist = erc20Recover.getTokenDenylist();
        IERC20[] memory expectedTokenDenylist;
        assertEq(actualTokenDenylist, expectedTokenDenylist);
    }

    /// @dev it should return an empty array.
    function testGetTokenDenylist__EmptyArray() external {
        IERC20[] memory tokenDenylist;
        erc20Recover.setTokenDenylist(tokenDenylist);

        IERC20[] memory actualTokenDenylist = erc20Recover.getTokenDenylist();
        IERC20[] memory expectedTokenDenylist;
        assertEq(actualTokenDenylist, expectedTokenDenylist);
    }

    /// @dev it should return the token denylist.
    function testGetTokenDenylist__NonEmptyArray() external {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
        IERC20[] memory actualTokenDenylist = erc20Recover.getTokenDenylist();
        IERC20[] memory expectedTokenDenylist = TOKEN_DENYLIST;
        assertEq(actualTokenDenylist, expectedTokenDenylist);
    }
}
