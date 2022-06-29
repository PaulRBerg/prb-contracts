// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20RecoverUnitTest } from "../ERC20RecoverUnitTest.t.sol";

contract ERC20Recover__IsTokenDenylistSet__TokenDenylistNotSet is ERC20RecoverUnitTest {
    /// @dev it should return false.
    function testIsTokenDenylistSet() external {
        bool isTokenDenylistSet = erc20Recover.isTokenDenylistSet();
        assertEq(isTokenDenylistSet, false);
    }
}

contract TokenDenylistSet is ERC20RecoverUnitTest {
    /// @dev A setup function invoked before each test case.
    function setUp() public override {
        super.setUp();
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
    }
}

contract ERC20Recover__IsTokenDenylistSet is TokenDenylistSet {
    /// @dev it should return true.
    function testIsTokenDenylistSet() external {
        bool isTokenDenylistSet = erc20Recover.isTokenDenylistSet();
        assertEq(isTokenDenylistSet, true);
    }
}
