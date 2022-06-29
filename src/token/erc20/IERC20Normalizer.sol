// SPDX-License-Identifier: Unlicense
// solhint-disable var-name-mixedcase
pragma solidity >=0.8.4;

import { IERC20 } from "./IERC20.sol";

/// @title IERC20Normalizer
/// @author Paul Razvan Berg
/// @notice Caches ERC-20 token decimals and scales the amounts up or down using 18 decimals as a frame of reference.
/// @dev Does not support ERC-20 tokens with decimals greater than 18.
interface IERC20Normalizer {
    /// CUSTOM ERRORS ///

    /// @notice Emitted when attempting to compute the scalar for a token whose decimals are zero.
    error IERC20Normalizer__TokenDecimalsZero(IERC20 token);

    /// @notice Emitted when attempting to compute the scalar for a token whose decimals are greater than 18.
    error IERC20Normalizer__TokenDecimalsGreaterThan18(IERC20 token, uint256 decimals);

    /// CONSTANT FUNCTIONS ///

    /// @notice Returns the scalar $10^(18 - decimals)$ for the given token.
    /// @dev Returns zero when there is no cached scalar for the given token.
    /// @param token The ERC-20 token to make the query for.
    /// @return scalar The scalar for the given token.
    function getScalar(IERC20 token) external view returns (uint256 scalar);

    /// NON-CONSTANT FUNCTIONS ///

    /// @notice Computes the scalar $10^(18 - decimals)$ for the given token.
    /// @param token The ERC-20 token to make the query for.
    /// @return scalar The newly computed scalar for the given token.
    function computeScalar(IERC20 token) external returns (uint256 scalar);

    /// @notice Denormalize the amount by diving by the token's scalar.
    /// @param token The ERC-20 token whose decimals are the units of the `amount` argumnet.
    /// @param amount The amount to denormalize, in units of the token's decimals.
    /// @param denormalizedAmount The amount denormalized with respect to `scalar`.
    function denormalize(IERC20 token, uint256 amount) external returns (uint256 denormalizedAmount);

    /// @notice Normalize the amount by multiplying by the token's scalar.
    /// @param token The ERC-20 token whose decimals are the units of `amount` argument.
    /// @param amount The amount to normalize, in units of the token's decimals.
    /// @param normalizedAmount The amount normalized with respect to `scalar`.
    function normalize(IERC20 token, uint256 amount) external returns (uint256 normalizedAmount);
}
