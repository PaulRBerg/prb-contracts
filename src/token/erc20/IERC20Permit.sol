// SPDX-License-Identifier: MIT
// solhint-disable func-name-mixedcase
pragma solidity >=0.8.4;

import { IERC20 } from "./IERC20.sol";

/// @title IERC20Permit
/// @author Paul Razvan Berg
/// @notice Extension of ERC-20 that allows token holders to use their tokens without sending any
/// transactions by setting the allowance with a signature using the `permit` method, and then spend
/// them via `transferFrom`.
/// @dev See https://eips.ethereum.org/EIPS/eip-2612.
interface IERC20Permit is IERC20 {
    /// CUSTOM ERRORS ///

    /// @notice Emitted when the recovered owner does not match the actual owner.
    error ERC20Permit__InvalidSignature(address owner, uint8 v, bytes32 r, bytes32 s);

    /// @notice Emitted when the owner is the zero address.
    error ERC20Permit__OwnerZeroAddress();

    /// @notice Emitted when the permit expired.
    error ERC20Permit__PermitExpired(uint256 currentTime, uint256 deadline);

    /// @notice Emitted when the recovered owner is the zero address.
    error ERC20Permit__RecoveredOwnerZeroAddress();

    /// @notice Emitted when attempting to permit the zero address as the spender.
    error ERC20Permit__SpenderZeroAddress();

    /// CONSTANT FUNCTIONS ///

    /// @notice The Eip712 domain's keccak256 hash.
    function DOMAIN_SEPARATOR() external view returns (bytes32);

    /// @notice keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    function PERMIT_TYPEHASH() external view returns (bytes32);

    /// @notice Provides replay protection.
    function nonces(address account) external view returns (uint256);

    /// @notice Eip712 version of this implementation.
    function version() external view returns (string memory);

    /// NON-CONSTANT FUNCTIONS ///

    /// @notice Sets `value` as the allowance of `spender` over `owner`'s tokens, assuming the latter's
    /// signed approval.
    ///
    /// @dev Emits an {Approval} event.
    ///
    /// IMPORTANT: The same issues ERC-20 `approve` has related to transaction
    /// ordering also apply here.
    ///
    /// Requirements:
    ///
    /// - `owner` cannot be the zero address.
    /// - `spender` cannot be the zero address.
    /// - `deadline` must be a timestamp in the future.
    /// - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner` over the Eip712-formatted
    /// function arguments.
    /// - The signature must use `owner`'s current nonce.
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}
