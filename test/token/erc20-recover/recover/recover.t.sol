// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { IAdminable } from "src/access/IAdminable.sol";
import { IERC20 } from "src/token/erc20/IERC20.sol";
import { IERC20Recover } from "src/token/erc20/IERC20Recover.sol";

import { ERC20RecoverTest } from "../ERC20Recover.t.sol";

contract Recover_Test is ERC20RecoverTest {
    /// @dev it should revert.
    function test_RevertWhen_CallerNotOwner() external {
        // Make Eve the caller in this test.
        address caller = users.eve;
        changePrank(caller);

        // Run the test.
        vm.expectRevert(abi.encodeWithSelector(IAdminable.Adminable_CallerNotAdmin.selector, users.admin, caller));
        erc20Recover.recover(dai, RECOVER_AMOUNT);
    }

    modifier CallerOwner() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_TokenDenylistNotSet() external CallerOwner {
        vm.expectRevert(IERC20Recover.ERC20Recover_TokenDenylistNotSet.selector);
        erc20Recover.recover(dai, RECOVER_AMOUNT);
    }

    modifier TokenDenylistSet() {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_RecoverAmountZero() external CallerOwner TokenDenylistSet {
        vm.expectRevert(IERC20Recover.ERC20Recover_RecoverAmountZero.selector);
        erc20Recover.recover(dai, 0);
    }

    modifier RecoverAmountNotZero() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_TokenNotRecoverable() external CallerOwner TokenDenylistSet RecoverAmountNotZero {
        IERC20 nonRecoverableToken = dai;
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Recover.ERC20Recover_RecoverNonRecoverableToken.selector, nonRecoverableToken)
        );
        erc20Recover.recover(nonRecoverableToken, bn(1, 18));
    }

    modifier TokenRecoverable() {
        _;
    }

    /// @dev it should recover the tokens.
    function test_Recover() external CallerOwner TokenDenylistSet RecoverAmountNotZero TokenRecoverable {
        erc20Recover.recover(usdc, RECOVER_AMOUNT);
    }

    /// @dev it should emit a Recover event.
    function test_Recover_Event() external CallerOwner TokenDenylistSet RecoverAmountNotZero TokenRecoverable {
        vm.expectEmit(true, false, false, true);
        emit Recover(users.admin, usdc, RECOVER_AMOUNT);
        erc20Recover.recover(usdc, RECOVER_AMOUNT);
    }
}
