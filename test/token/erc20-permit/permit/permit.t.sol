// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { IERC20Permit } from "src/token/erc20/IERC20Permit.sol";

import { ERC20Permit_Test } from "../ERC20Permit.t.sol";

contract Permit_Test is ERC20Permit_Test {
    function test_RevertWhen_OwnerZeroAddress() external {
        vm.expectRevert(IERC20Permit.ERC20Permit_OwnerZeroAddress.selector);
        erc20Permit.permit({
            owner: address(0),
            spender: users.alice,
            value: 1,
            deadline: DECEMBER_2099,
            v: DUMMY_V,
            r: DUMMY_R,
            s: DUMMY_S
        });
    }

    modifier whenOwnerNotZeroAddress() {
        _;
    }

    function test_RevertWhen_SpenderZeroAddress() external whenOwnerNotZeroAddress {
        vm.expectRevert(IERC20Permit.ERC20Permit_SpenderZeroAddress.selector);
        erc20Permit.permit({
            owner: users.alice,
            spender: address(0),
            value: 1,
            deadline: DECEMBER_2099,
            v: DUMMY_V,
            r: DUMMY_R,
            s: DUMMY_S
        });
    }

    modifier whenSpenderNotZeroAddress() {
        _;
    }

    function test_RevertWhen_DeadlineInThePast(uint256 deadline)
        external
        whenOwnerNotZeroAddress
        whenSpenderNotZeroAddress
    {
        deadline = _bound(deadline, 0, block.timestamp - 1 seconds);

        vm.expectRevert(
            abi.encodeWithSelector(IERC20Permit.ERC20Permit_PermitExpired.selector, block.timestamp, deadline)
        );
        erc20Permit.permit({
            owner: users.alice,
            spender: users.bob,
            value: 1,
            deadline: deadline,
            v: DUMMY_V,
            r: DUMMY_R,
            s: DUMMY_S
        });
    }

    modifier whenDeadlineNotInThePast() {
        _;
    }

    /// @dev Setting `v` to any number other than 27 or 28 makes the `ecrecover` precompile return the zero address.
    /// https://ethereum.stackexchange.com/questions/69328/how-to-get-the-zero-address-from-ecrecover
    function test_RevertWhen_RecoveredOwnerZeroAddress(
        uint256 deadline,
        uint8 v
    )
        external
        whenOwnerNotZeroAddress
        whenSpenderNotZeroAddress
        whenDeadlineNotInThePast
    {
        vm.assume(v != 27 && v != 28);
        deadline = _bound(deadline, block.timestamp, DECEMBER_2099);

        vm.expectRevert(IERC20Permit.ERC20Permit_RecoveredOwnerZeroAddress.selector);
        erc20Permit.permit({
            owner: users.alice,
            spender: users.bob,
            value: 1,
            deadline: deadline,
            v: v,
            r: DUMMY_R,
            s: DUMMY_S
        });
    }

    modifier whenRecoveredOwnerNotZeroAddress() {
        _;
    }

    function test_RevertWhen_SignatureNotValid(uint256 deadline)
        external
        whenOwnerNotZeroAddress
        whenSpenderNotZeroAddress
        whenDeadlineNotInThePast
        whenRecoveredOwnerNotZeroAddress
    {
        deadline = _bound(deadline, block.timestamp, DECEMBER_2099);

        address owner = users.alice;
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Permit.ERC20Permit_InvalidSignature.selector, owner, DUMMY_V, DUMMY_R, DUMMY_S)
        );
        erc20Permit.permit({
            owner: owner,
            spender: users.bob,
            value: 1,
            deadline: deadline,
            v: DUMMY_V,
            r: DUMMY_R,
            s: DUMMY_S
        });
    }

    modifier whenSignatureValid() {
        _;
    }

    function testFuzz_Permit(
        uint256 privateKey,
        address spender,
        uint256 value,
        uint256 deadline
    )
        external
        whenOwnerNotZeroAddress
        whenSpenderNotZeroAddress
        whenDeadlineNotInThePast
        whenRecoveredOwnerNotZeroAddress
        whenSignatureValid
    {
        vm.assume(spender != address(0));
        privateKey = boundPrivateKey(privateKey);
        deadline = _bound(deadline, block.timestamp, DECEMBER_2099);

        address owner = vm.addr(privateKey);
        (uint8 v, bytes32 r, bytes32 s) = getSignature(privateKey, owner, spender, value, deadline);
        erc20Permit.permit(owner, spender, value, deadline, v, r, s);
        uint256 actualAllowance = erc20Permit.allowance(owner, spender);
        uint256 expectedAllowance = value;
        assertEq(actualAllowance, expectedAllowance, "allowance");
    }

    function testFuzz_Permit_IncreaseNonce(
        uint256 privateKey,
        address spender,
        uint256 value,
        uint256 deadline
    )
        external
        whenOwnerNotZeroAddress
        whenSpenderNotZeroAddress
        whenDeadlineNotInThePast
        whenRecoveredOwnerNotZeroAddress
        whenSignatureValid
    {
        vm.assume(spender != address(0));
        privateKey = boundPrivateKey(privateKey);
        deadline = _bound(deadline, block.timestamp, DECEMBER_2099);

        address owner = vm.addr(privateKey);
        (uint8 v, bytes32 r, bytes32 s) = getSignature(privateKey, owner, spender, value, deadline);
        erc20Permit.permit(owner, spender, value, deadline, v, r, s);
        uint256 actualNonce = erc20Permit.nonces(owner);
        uint256 expectedNonce = 1;
        assertEq(actualNonce, expectedNonce, "nonce");
    }

    function testFuzz_Permit_Approval(
        uint256 privateKey,
        address spender,
        uint256 value,
        uint256 deadline
    )
        external
        whenOwnerNotZeroAddress
        whenSpenderNotZeroAddress
        whenDeadlineNotInThePast
        whenRecoveredOwnerNotZeroAddress
        whenSignatureValid
    {
        vm.assume(spender != address(0));
        privateKey = boundPrivateKey(privateKey);
        deadline = _bound(deadline, block.timestamp, DECEMBER_2099);

        address owner = vm.addr(privateKey);
        vm.expectEmit({ emitter: address(erc20Permit) });
        emit Approval(owner, spender, value);
        (uint8 v, bytes32 r, bytes32 s) = getSignature(privateKey, owner, spender, value, deadline);
        erc20Permit.permit(owner, spender, value, deadline, v, r, s);
    }
}
