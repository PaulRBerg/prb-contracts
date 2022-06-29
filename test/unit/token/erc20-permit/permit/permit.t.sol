// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20Permit } from "@prb/contracts/token/erc20/IERC20Permit.sol";

import { console } from "forge-std/Test.sol";

import { ERC20PermitUnitTest } from "../ERC20PermitUnitTest.t.sol";

contract ERC20Permit__Permit is ERC20PermitUnitTest {
    /// @dev it should revert.
    function testCannotPermit__OwnerZeroAddress() external {
        address owner = address(0);
        address spender = users.alice;
        uint256 value = 1;
        uint256 deadline = DECEMBER_2099;
        vm.expectRevert(IERC20Permit.ERC20Permit__OwnerZeroAddress.selector);
        erc20Permit.permit(owner, spender, value, deadline, DUMMY_V, DUMMY_R, DUMMY_S);
    }

    modifier OwnerNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testCannotPermit__SpenderZeroAddress() external OwnerNotZeroAddress {
        address owner = users.alice;
        address spender = address(0);
        uint256 value = 1;
        uint256 deadline = DECEMBER_2099;
        vm.expectRevert(IERC20Permit.ERC20Permit__SpenderZeroAddress.selector);
        erc20Permit.permit(owner, spender, value, deadline, DUMMY_V, DUMMY_R, DUMMY_S);
    }

    modifier SpenderNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testCannotPermit__DeadlineInThePast(uint256 deadline) external OwnerNotZeroAddress SpenderNotZeroAddress {
        vm.assume(deadline < block.timestamp);

        address owner = users.alice;
        address spender = users.bob;
        uint256 value = 1;
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Permit.ERC20Permit__PermitExpired.selector, block.timestamp, deadline)
        );
        erc20Permit.permit(owner, spender, value, deadline, DUMMY_V, DUMMY_R, DUMMY_S);
    }

    modifier DeadlineNotInThePast() {
        _;
    }

    /// @dev it should revert.
    ///
    /// Setting `v` to any number other than 27 or 28 makes the `ecrecover` precompile return the zero address.
    /// https://ethereum.stackexchange.com/questions/69328/how-to-get-the-zero-address-from-ecrecover
    function testCannotPermit__RecoveredOwnerZeroAddress(uint256 deadline, uint8 v)
        external
        OwnerNotZeroAddress
        SpenderNotZeroAddress
        DeadlineNotInThePast
    {
        vm.assume(deadline >= block.timestamp);
        vm.assume(v != 27 && v != 28);

        address owner = users.alice;
        address spender = users.bob;
        uint256 value = 1;
        vm.expectRevert(IERC20Permit.ERC20Permit__RecoveredOwnerZeroAddress.selector);
        erc20Permit.permit(owner, spender, value, deadline, v, DUMMY_R, DUMMY_S);
    }

    modifier RecoveredOwnerNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testCannotPermit__SignatureNotValid(uint256 deadline)
        external
        OwnerNotZeroAddress
        SpenderNotZeroAddress
        DeadlineNotInThePast
        RecoveredOwnerNotZeroAddress
    {
        vm.assume(deadline >= block.timestamp);
        address owner = users.alice;
        address spender = users.bob;
        uint256 value = 1;
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Permit.ERC20Permit__InvalidSignature.selector,
                owner,
                DUMMY_V,
                DUMMY_R,
                DUMMY_S
            )
        );
        erc20Permit.permit(owner, spender, value, deadline, DUMMY_V, DUMMY_R, DUMMY_S);
    }

    modifier SignatureValid() {
        _;
    }

    /// @dev it should update the spender's allowance.
    function testPermit(
        uint256 privateKey,
        address spender,
        uint256 value,
        uint256 deadline
    )
        external
        OwnerNotZeroAddress
        SpenderNotZeroAddress
        DeadlineNotInThePast
        RecoveredOwnerNotZeroAddress
        SignatureValid
    {
        vm.assume(privateKey > 0);
        vm.assume(privateKey < SECP256K1_ORDER);
        vm.assume(spender != address(0));
        vm.assume(deadline >= block.timestamp);

        address owner = vm.addr(privateKey);
        (uint8 v, bytes32 r, bytes32 s) = getSignature(privateKey, owner, spender, value, deadline);
        erc20Permit.permit(owner, spender, value, deadline, v, r, s);
        uint256 actualAllowance = erc20Permit.allowance(owner, spender);
        uint256 expectedAlowance = value;
        assertEq(actualAllowance, expectedAlowance);
    }

    /// @dev it should increase the nonce of the owner.
    function testPermit__IncreaseNonce(
        uint256 privateKey,
        address spender,
        uint256 value,
        uint256 deadline
    )
        external
        OwnerNotZeroAddress
        SpenderNotZeroAddress
        DeadlineNotInThePast
        RecoveredOwnerNotZeroAddress
        SignatureValid
    {
        vm.assume(privateKey > 0);
        vm.assume(privateKey < SECP256K1_ORDER);
        vm.assume(spender != address(0));
        vm.assume(deadline >= block.timestamp);

        address owner = vm.addr(privateKey);
        (uint8 v, bytes32 r, bytes32 s) = getSignature(privateKey, owner, spender, value, deadline);
        erc20Permit.permit(owner, spender, value, deadline, v, r, s);
        uint256 actualNonce = erc20Permit.nonces(owner);
        uint256 expectedNonce = 1;
        assertEq(actualNonce, expectedNonce);
    }

    /// @dev it should emit an Approval event.
    function testPermit__Approval(
        uint256 privateKey,
        address spender,
        uint256 value,
        uint256 deadline
    )
        external
        OwnerNotZeroAddress
        SpenderNotZeroAddress
        DeadlineNotInThePast
        RecoveredOwnerNotZeroAddress
        SignatureValid
    {
        vm.assume(privateKey > 0);
        vm.assume(privateKey < SECP256K1_ORDER);
        vm.assume(spender != address(0));
        vm.assume(deadline >= block.timestamp);

        address owner = vm.addr(privateKey);
        vm.expectEmit(true, true, false, true);
        emit Approval(owner, spender, value);
        (uint8 v, bytes32 r, bytes32 s) = getSignature(privateKey, owner, spender, value, deadline);
        erc20Permit.permit(owner, spender, value, deadline, v, r, s);
    }
}
