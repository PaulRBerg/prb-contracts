// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { ERC20RecoverUnitTest } from "../ERC20RecoverUnitTest.t.sol";

contract ERC20Recover__GetTokenDenylist__TokenDenylistNotSet is ERC20RecoverUnitTest {
    /// @dev it should return an empty array.
    function testGetTokenDenylist() external {
        IERC20[] memory actualTokenDenylist = erc20Recover.getTokenDenylist();
        IERC20[] memory expectedTokenDenylist;
        assertEq(actualTokenDenylist, expectedTokenDenylist);
    }
}

contract ERC20Recover__GetTokenDenylist__EmptyArray is ERC20RecoverUnitTest {
    /// @dev A setup function invoked before each test case.
    function setUp() public override {
        super.setUp();
        IERC20[] memory tokenDenylist;
        erc20Recover.setTokenDenylist(tokenDenylist);
    }

    /// @dev it should return an empty array.
    function testGetTokenDenylist() external {
        IERC20[] memory actualTokenDenylist = erc20Recover.getTokenDenylist();
        IERC20[] memory expectedTokenDenylist;
        assertEq(actualTokenDenylist, expectedTokenDenylist);
    }
}

contract ERC20Recover__GetTokenDenylist__NonEmptyArray is ERC20RecoverUnitTest {
    /// @dev A setup function invoked before each test case.
    function setUp() public override {
        super.setUp();
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
    }

    /// @dev it should return the token denylist.
    function testGetTokenDenylist() external {
        IERC20[] memory actualTokenDenylist = erc20Recover.getTokenDenylist();
        IERC20[] memory expectedTokenDenylist = TOKEN_DENYLIST;
        assertEq(actualTokenDenylist, expectedTokenDenylist);
    }
}
