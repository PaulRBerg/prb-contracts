// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { IAdminable } from "src/access/IAdminable.sol";
import { IERC20 } from "src/token/erc20/IERC20.sol";
import { IERC20Recover } from "src/token/erc20/IERC20Recover.sol";

import { ERC20Recover_Test } from "../ERC20Recover.t.sol";

contract Recover_Test is ERC20Recover_Test {
    /// @dev it should revert.
    function test_RevertWhen_CallerNotOwner() external {
        // Make Eve the caller in this test.
        address caller = users.eve;
        changePrank(caller);

        // Run the test.
        vm.expectRevert(abi.encodeWithSelector(IAdminable.Adminable_CallerNotAdmin.selector, users.admin, caller));
        erc20Recover.recover({ token: dai, amount: DEFAULT_RECOVER_AMOUNT });
    }

    modifier whenCallerOwner() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_TokenDenylistNotSet() external whenCallerOwner {
        vm.expectRevert(IERC20Recover.ERC20Recover_TokenDenylistNotSet.selector);
        erc20Recover.recover({ token: dai, amount: DEFAULT_RECOVER_AMOUNT });
    }

    modifier whenTokenDenylistSet() {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_RecoverAmountZero() external whenCallerOwner whenTokenDenylistSet {
        vm.expectRevert(IERC20Recover.ERC20Recover_RecoverAmountZero.selector);
        erc20Recover.recover({ token: dai, amount: 0 });
    }

    modifier whenRecoverAmountNotZero() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_TokenNotRecoverable()
        external
        whenCallerOwner
        whenTokenDenylistSet
        whenRecoverAmountNotZero
    {
        IERC20 nonRecoverableToken = dai;
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Recover.ERC20Recover_RecoverNonRecoverableToken.selector, nonRecoverableToken)
        );
        erc20Recover.recover({ token: nonRecoverableToken, amount: 1e18 });
    }

    modifier whenTokenRecoverable() {
        _;
    }

    /// @dev it should recover the tokens.
    function test_Recover()
        external
        whenCallerOwner
        whenTokenDenylistSet
        whenRecoverAmountNotZero
        whenTokenRecoverable
    {
        erc20Recover.recover({ token: usdc, amount: DEFAULT_RECOVER_AMOUNT });
    }

    /// @dev it should emit a {Recover} event.
    function test_Recover_Event()
        external
        whenCallerOwner
        whenTokenDenylistSet
        whenRecoverAmountNotZero
        whenTokenRecoverable
    {
        vm.expectEmit();
        emit Recover({ owner: users.admin, token: usdc, amount: DEFAULT_RECOVER_AMOUNT });
        erc20Recover.recover({ token: usdc, amount: DEFAULT_RECOVER_AMOUNT });
    }
}
