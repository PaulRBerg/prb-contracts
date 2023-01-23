// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { IERC20Permit } from "src/token/erc20/IERC20Permit.sol";

import { ERC20PermitTest } from "../ERC20Permit.t.sol";

contract Permit_Test is ERC20PermitTest {
    /// @dev it should revert.
    function test_RevertWhen_OwnerZeroAddress() external {
        address owner = address(0);
        address spender = users.alice;
        uint256 value = 1;
        uint256 deadline = DECEMBER_2099;
        vm.expectRevert(IERC20Permit.ERC20Permit_OwnerZeroAddress.selector);
        erc20Permit.permit(owner, spender, value, deadline, DUMMY_V, DUMMY_R, DUMMY_S);
    }

    modifier ownerNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_SpenderZeroAddress() external ownerNotZeroAddress {
        address owner = users.alice;
        address spender = address(0);
        uint256 value = 1;
        uint256 deadline = DECEMBER_2099;
        vm.expectRevert(IERC20Permit.ERC20Permit_SpenderZeroAddress.selector);
        erc20Permit.permit(owner, spender, value, deadline, DUMMY_V, DUMMY_R, DUMMY_S);
    }

    modifier spenderNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_DeadlineInThePast(uint256 deadline) external ownerNotZeroAddress spenderNotZeroAddress {
        vm.assume(deadline < block.timestamp);

        address owner = users.alice;
        address spender = users.bob;
        uint256 value = 1;
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Permit.ERC20Permit_PermitExpired.selector, block.timestamp, deadline)
        );
        erc20Permit.permit(owner, spender, value, deadline, DUMMY_V, DUMMY_R, DUMMY_S);
    }

    modifier deadlineNotInThePast() {
        _;
    }

    /// @dev it should revert.
    ///
    /// Setting `v` to any number other than 27 or 28 makes the `ecrecover` precompile return the zero address.
    /// https://ethereum.stackexchange.com/questions/69328/how-to-get-the-zero-address-from-ecrecover
    function test_RevertWhen_RecoveredOwnerZeroAddress(uint256 deadline, uint8 v)
        external
        ownerNotZeroAddress
        spenderNotZeroAddress
        deadlineNotInThePast
    {
        vm.assume(deadline >= block.timestamp);
        vm.assume(v != 27 && v != 28);

        address owner = users.alice;
        address spender = users.bob;
        uint256 value = 1;
        vm.expectRevert(IERC20Permit.ERC20Permit_RecoveredOwnerZeroAddress.selector);
        erc20Permit.permit(owner, spender, value, deadline, v, DUMMY_R, DUMMY_S);
    }

    modifier recoveredOwnerNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_SignatureNotValid(uint256 deadline)
        external
        ownerNotZeroAddress
        spenderNotZeroAddress
        deadlineNotInThePast
        recoveredOwnerNotZeroAddress
    {
        vm.assume(deadline >= block.timestamp);
        address owner = users.alice;
        address spender = users.bob;
        uint256 value = 1;
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Permit.ERC20Permit_InvalidSignature.selector, owner, DUMMY_V, DUMMY_R, DUMMY_S)
        );
        erc20Permit.permit(owner, spender, value, deadline, DUMMY_V, DUMMY_R, DUMMY_S);
    }

    modifier signatureValid() {
        _;
    }

    /// @dev Checks common assumptions for the tests below.
    function checkAssumptions(
        uint256 privateKey,
        address spender,
        uint256 deadline
    ) internal view {
        vm.assume(privateKey > 0 && privateKey < SECP256K1_ORDER);
        vm.assume(spender != address(0));
        vm.assume(deadline >= block.timestamp);
    }

    /// @dev it should update the spender's allowance.
    function testFuzz_Permit(
        uint256 privateKey,
        address spender,
        uint256 value,
        uint256 deadline
    )
        external
        ownerNotZeroAddress
        spenderNotZeroAddress
        deadlineNotInThePast
        recoveredOwnerNotZeroAddress
        signatureValid
    {
        checkAssumptions(privateKey, spender, deadline);

        address owner = vm.addr(privateKey);
        (uint8 v, bytes32 r, bytes32 s) = getSignature(privateKey, owner, spender, value, deadline);
        erc20Permit.permit(owner, spender, value, deadline, v, r, s);
        uint256 actualAllowance = erc20Permit.allowance(owner, spender);
        uint256 expectedAllowance = value;
        assertEq(actualAllowance, expectedAllowance);
    }

    /// @dev it should increase the nonce of the owner.
    function testFuzz_Permit_IncreaseNonce(
        uint256 privateKey,
        address spender,
        uint256 value,
        uint256 deadline
    )
        external
        ownerNotZeroAddress
        spenderNotZeroAddress
        deadlineNotInThePast
        recoveredOwnerNotZeroAddress
        signatureValid
    {
        checkAssumptions(privateKey, spender, deadline);

        address owner = vm.addr(privateKey);
        (uint8 v, bytes32 r, bytes32 s) = getSignature(privateKey, owner, spender, value, deadline);
        erc20Permit.permit(owner, spender, value, deadline, v, r, s);
        uint256 actualNonce = erc20Permit.nonces(owner);
        uint256 expectedNonce = 1;
        assertEq(actualNonce, expectedNonce);
    }

    /// @dev it should emit an Approval event.
    function testFuzz_Permit_Approval(
        uint256 privateKey,
        address spender,
        uint256 value,
        uint256 deadline
    )
        external
        ownerNotZeroAddress
        spenderNotZeroAddress
        deadlineNotInThePast
        recoveredOwnerNotZeroAddress
        signatureValid
    {
        checkAssumptions(privateKey, spender, deadline);

        address owner = vm.addr(privateKey);
        vm.expectEmit({ checkTopic1: true, checkTopic2: true, checkTopic3: false, checkData: true });
        emit Approval(owner, spender, value);
        (uint8 v, bytes32 r, bytes32 s) = getSignature(privateKey, owner, spender, value, deadline);
        erc20Permit.permit(owner, spender, value, deadline, v, r, s);
    }
}
