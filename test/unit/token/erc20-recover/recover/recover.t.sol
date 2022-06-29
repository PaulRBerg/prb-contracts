// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";
import { IERC20Recover } from "@prb/contracts/token/erc20/IERC20Recover.sol";
import { IOwnable } from "@prb/contracts/access/IOwnable.sol";

import { ERC20RecoverUnitTest } from "../ERC20RecoverUnitTest.t.sol";

contract ERC20Recover__Recover__CallerNotOwner is ERC20RecoverUnitTest {
    /// @dev it should revert.
    function testCannotRecover() external {
        // Make Eve the caller in this test.
        address caller = users.eve;
        changePrank(caller);

        // Run the test.
        address owner = users.alice;
        vm.expectRevert(abi.encodeWithSelector(IOwnable.Ownable__NotOwner.selector, owner, caller));
        erc20Recover.recover(dai, RECOVER_AMOUNT);
    }
}

contract CallerOwner {}

contract ERC20Recover__Recover__TokenDenylistNotSet is ERC20RecoverUnitTest, CallerOwner {
    /// @dev it should revert.
    function testCannotRecover() external {
        vm.expectRevert(IERC20Recover.ERC20Recover__TokenDenylistNotSet.selector);
        erc20Recover.recover(dai, RECOVER_AMOUNT);
    }
}

contract TokenDenylistSet is ERC20RecoverUnitTest {
    /// @dev A setup function invoked before each test case.
    function setUp() public override {
        super.setUp();
        erc20Recover.setTokenDenylist(TOKEN_DENYLIST);
    }
}

contract ERC20Recover__Recover__RecoverAmountZero is CallerOwner, TokenDenylistSet {
    /// @dev it should revert.
    function testCannotRecover() external {
        vm.expectRevert(IERC20Recover.ERC20Recover__RecoverAmountZero.selector);
        erc20Recover.recover(dai, 0);
    }
}

contract RecoverAmountNotZero {}

contract ERC20Recover__Recover__TokenNotRecoverable is CallerOwner, TokenDenylistSet, RecoverAmountNotZero {
    /// @dev it should revert.
    function testCannotRecover() external {
        IERC20 nonRecoverableToken = dai;
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Recover.ERC20Recover__RecoverNonRecoverableToken.selector, nonRecoverableToken)
        );
        erc20Recover.recover(nonRecoverableToken, bn(1, 18));
    }
}

contract TokenRecoverable {}

contract ERC20Recover__Recover is CallerOwner, TokenDenylistSet, RecoverAmountNotZero, TokenRecoverable {
    /// @dev it should recover the tokens.
    function testRecover() external {
        erc20Recover.recover(usdc, RECOVER_AMOUNT);
    }

    /// @dev it should emit a Recover event.
    function testRecover__Event() external {
        vm.expectEmit(true, false, false, true);
        address owner = users.alice;
        emit Recover(owner, usdc, RECOVER_AMOUNT);
        erc20Recover.recover(usdc, RECOVER_AMOUNT);
    }
}
