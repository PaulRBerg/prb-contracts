// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";
import { IERC20Recover } from "@prb/contracts/token/erc20/IERC20Recover.sol";
import { IOwnable } from "@prb/contracts/access/IOwnable.sol";

import { ERC20RecoverTest } from "../ERC20RecoverTest.t.sol";

contract ERC20Recover__Recover is ERC20RecoverTest {
    /// @dev it should revert.
    function testCannotRecover__CallerNotOwner() external {
        // Make Eve the caller in this test.
        address caller = users.eve;
        changePrank(caller);

        // Run the test.
        address owner = users.alice;
        vm.expectRevert(abi.encodeWithSelector(IOwnable.Ownable__NotOwner.selector, owner, caller));
        erc20Recover.recover(dai, RECOVER_AMOUNT);
    }

    modifier CallerOwner() {
        _;
    }

    /// @dev it should revert.
    function testCannotRecover__TokenDenylistNotSet() external CallerOwner {
        vm.expectRevert(IERC20Recover.ERC20Recover__TokenDenylistNotSet.selector);
        erc20Recover.recover(dai, RECOVER_AMOUNT);
    }

    modifier TokenDenylistSet() {
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
        _;
    }

    /// @dev it should revert.
    function testCannotRecover__RecoverAmountZero() external CallerOwner TokenDenylistSet {
        vm.expectRevert(IERC20Recover.ERC20Recover__RecoverAmountZero.selector);
        erc20Recover.recover(dai, 0);
    }

    modifier RecoverAmountNotZero() {
        _;
    }

    /// @dev it should revert.
    function testCannotRecover__TokenNotRecoverable() external CallerOwner TokenDenylistSet RecoverAmountNotZero {
        IERC20 nonRecoverableToken = dai;
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Recover.ERC20Recover__RecoverNonRecoverableToken.selector, nonRecoverableToken)
        );
        erc20Recover.recover(nonRecoverableToken, bn(1, 18));
    }

    modifier TokenRecoverable() {
        _;
    }

    /// @dev it should recover the tokens.
    function testRecover() external CallerOwner TokenDenylistSet RecoverAmountNotZero TokenRecoverable {
        erc20Recover.recover(usdc, RECOVER_AMOUNT);
    }

    /// @dev it should emit a Recover event.
    function testRecover__Event() external CallerOwner TokenDenylistSet RecoverAmountNotZero TokenRecoverable {
        vm.expectEmit(true, false, false, true);
        address owner = users.alice;
        emit Recover(owner, usdc, RECOVER_AMOUNT);
        erc20Recover.recover(usdc, RECOVER_AMOUNT);
    }
}
