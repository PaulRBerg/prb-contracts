// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { IAdminable } from "src/access/IAdminable.sol";
import { IERC20 } from "src/token/erc20/IERC20.sol";
import { IERC20Recover } from "src/token/erc20/IERC20Recover.sol";

import { ERC20Recover_Test } from "../ERC20Recover.t.sol";

contract SetTokenDenylist_Test is ERC20Recover_Test {
    /// @dev it should revert.
    function test_RevertWhen_CallerNotAdmin() external {
        // Make Eve the caller in this test.
        address caller = users.eve;
        changePrank(caller);

        // Run the test.
        vm.expectRevert(abi.encodeWithSelector(IAdminable.Adminable_CallerNotAdmin.selector, users.admin, caller));
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
    }

    modifier callerAdmin() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_TokenDenylistAlreadySet() external callerAdmin {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
        vm.expectRevert(IERC20Recover.ERC20Recover_TokenDenylistAlreadySet.selector);
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
    }

    modifier tokenDenylistNotAlreadySet() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_SomeTokensDontHaveASymbol() external callerAdmin tokenDenylistNotAlreadySet {
        vm.expectRevert();
        IERC20[] memory tokenDenylist = new IERC20[](2);
        tokenDenylist[0] = dai;
        tokenDenylist[1] = IERC20(address(symbollessToken));
        erc20Recover.setTokenDenylist(tokenDenylist);
    }

    modifier allTokensHaveASymbol() {
        _;
    }

    /// @dev it should set the token denylist.
    function test_SetTokenDenylist() external callerAdmin tokenDenylistNotAlreadySet allTokensHaveASymbol {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);

        // Compare the token denylists.
        IERC20[] memory actualTokenDenylist = erc20Recover.getTokenDenylist();
        IERC20[] memory expectedTokenDenylist = TOKEN_DENYLIST;
        assertEq(actualTokenDenylist, expectedTokenDenylist, "tokenDenylist");

        // Check that the flag has been set to true.
        bool isTokenDenylistSet = erc20Recover.isTokenDenylistSet();
        assertTrue(isTokenDenylistSet, "isTokenDenylistSet");
    }

    /// @dev it should emit a {SetTokenDenylist} event.
    function test_SetTokenDenylist_Event() external callerAdmin tokenDenylistNotAlreadySet allTokensHaveASymbol {
        vm.expectEmit();
        emit SetTokenDenylist({ owner: users.admin, tokenDenylist: TOKEN_DENYLIST });
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
    }
}
