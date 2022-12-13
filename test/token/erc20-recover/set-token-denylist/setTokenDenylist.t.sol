// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";
import { IERC20Recover } from "@prb/contracts/token/erc20/IERC20Recover.sol";
import { IOwnable } from "@prb/contracts/access/IOwnable.sol";

import { ERC20RecoverTest } from "../ERC20RecoverTest.t.sol";

contract ERC20Recover__SetTokenDenylist is ERC20RecoverTest {
    /// @dev it should revert.
    function testCannotSetTokenDenylist__CallerNotOwner() external {
        // Make Eve the caller in this test.
        address caller = users.eve;
        changePrank(caller);

        // Run the test.
        address owner = users.alice;
        vm.expectRevert(abi.encodeWithSelector(IOwnable.Ownable__CallerNotOwner.selector, owner, caller));
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
    }

    modifier CallerOwner() {
        _;
    }

    /// @dev it should revert.
    function testCannotSetTokenDenylist__TokenDenylistAlreadySet() external CallerOwner {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
        vm.expectRevert(IERC20Recover.ERC20Recover__TokenDenylistAlreadySet.selector);
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
    }

    modifier TokenDenylistNotAlreadySet() {
        _;
    }

    /// @dev it should revert.
    function testCannotSetTokenDenylist__SomeTokensDontHaveASymbol() external CallerOwner TokenDenylistNotAlreadySet {
        vm.expectRevert();
        IERC20[] memory tokenDenylist = new IERC20[](2);
        tokenDenylist[0] = dai;
        tokenDenylist[1] = IERC20(address(symbollessToken));
        erc20Recover.setTokenDenylist(tokenDenylist);
    }

    modifier AllTokensHaveASymbol() {
        _;
    }

    /// @dev it should set the token denylist.
    function testSetTokenDenylist() external CallerOwner TokenDenylistNotAlreadySet AllTokensHaveASymbol {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);

        // Compare the token denylists.
        IERC20[] memory actualTokenDenylist = erc20Recover.getTokenDenylist();
        IERC20[] memory expectedTokenDenylist = TOKEN_DENYLIST;
        assertEq(actualTokenDenylist, expectedTokenDenylist);

        // Check that the flag has been set to true.
        bool isTokenDenylistSet = erc20Recover.isTokenDenylistSet();
        assertEq(isTokenDenylistSet, true);
    }

    /// @dev it should emit a SetTokenDenylist event.
    function testSetTokenDenylist__Event() external CallerOwner TokenDenylistNotAlreadySet AllTokensHaveASymbol {
        vm.expectEmit(true, false, false, true);
        emit SetTokenDenylist(users.alice, TOKEN_DENYLIST);
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
    }
}
