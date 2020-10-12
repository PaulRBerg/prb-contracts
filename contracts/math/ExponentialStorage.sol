/* SPDX-License-Identifier: LPGL-3.0-or-later */
pragma solidity ^0.7.3;

/**
 * @title ExponentialStorage
 * @author Paul Razvan Berg
 * @notice The storage interface ancillary to an Exponential contract.
 */
abstract contract ExponentialStorage {
    struct Exp {
        uint256 mantissa;
    }

    /**
     * @notice In Exponential denomination, 1e18 is 1.
     */
    uint256 public constant expScale = 1e18;
    uint256 public constant halfExpScale = expScale / 2;
    uint256 public constant mantissaOne = expScale;
}
