// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "./IERC20.sol";
import "./IERC20Normalizer.sol";

/// @title ERC20Normalizer
/// @author Paul Razvan Berg
abstract contract ERC20Normalizer is IERC20Normalizer {
    /// INTERNAL STORAGE ///

    /// @dev Mapping between ERC-20 tokens and their associated scalars $10^(18 - decimals)$.
    mapping(IERC20 => uint256) internal scalars;

    /// CONSTANT FUNCTIONS ///

    /// @inheritdoc IERC20Normalizer
    function getScalar(IERC20 token) public view override returns (uint256 scalar) {
        // Check if we already have a cached scalar for the given token.
        scalar = scalars[token];
    }

    /// NON-CONSTANT FUNCTIONS ///

    /// @inheritdoc IERC20Normalizer
    function computeScalar(IERC20 token) public returns (uint256 scalar) {
        // Query the ERC-20 contract to obtain the decimals.
        uint256 decimals = uint256(token.decimals());

        // Revert if the token's decimals are zero.
        if (decimals == 0) {
            revert IERC20Normalizer__TokenDecimalsZero(token);
        }

        // Revert if the token's decimals are greater than 18.
        if (decimals > 18) {
            revert IERC20Normalizer__TokenDecimalsGreaterThan18(token, decimals);
        }

        // Calculate the scalar.
        unchecked {
            scalar = 10**(18 - decimals);
        }

        // Save the scalar in storage.
        scalars[token] = scalar;
    }

    /// @inheritdoc IERC20Normalizer
    function denormalize(IERC20 token, uint256 amount) external returns (uint256 denormalizedAmount) {
        uint256 scalar = getScalar(token);

        // If the scalar is zero, it means that this is the first time we encounter this ERC-20 token. We compute
        // its precision scalar and cache it.
        if (scalar == 0) {
            scalar = computeScalar(token);
        }

        // Denormalize the amount. It is safe to use unchecked arithmetic because we do not allow tokens with decimals
        // greater than 18.
        unchecked {
            denormalizedAmount = scalar != 1 ? amount / scalar : amount;
        }
    }

    /// @inheritdoc IERC20Normalizer
    function normalize(IERC20 token, uint256 amount) external returns (uint256 normalizedAmount) {
        uint256 scalar = getScalar(token);

        // If the scalar is zero, it means that this is the first time we encounter this ERC-20 token. We need
        // to compute its precision scalar and cache it.
        if (scalar == 0) {
            scalar = computeScalar(token);
        }

        // Normalize the amount. We have to use checked arithmetic because the calculation can overflow uint256.
        normalizedAmount = scalar != 1 ? amount * scalar : amount;
    }
}
