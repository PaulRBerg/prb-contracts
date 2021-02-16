// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ExponentialStorage.sol";

/// @title Exponential module for storing fixed-precision decimals.
/// @author Paul Razvan Berg
/// @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
/// Therefore, if we wanted to store the 5.1, mantissa would store 5.1e18: `Exp({mantissa: 5100000000000000000})`.
/// @dev Forked from Compound
/// https://github.com/compound-finance/compound-protocol/blob/v2.8.1/contracts/Exponential.sol
abstract contract Exponential is ExponentialStorage {
    /// @dev Adds two exponentials, returning a new exponential.
    function addExp(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
        uint256 result = a.mantissa + b.mantissa;
        return Exp({ mantissa: result });
    }

    /// @dev Divides two exponentials, returning a new exponential.
    /// (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b.
    function divExp(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
        uint256 scaledNumerator = a.mantissa * expScale;
        uint256 rational = scaledNumerator / b.mantissa;
        return Exp({ mantissa: rational });
    }

    /// @dev Multiplies two exponentials, returning a new exponential.
    function mulExp(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
        uint256 doubleScaledProduct = a.mantissa * b.mantissa;

        // We add half the scale before dividing so that we get rounding instead of truncation.
        // See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
        // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
        uint256 doubleScaledProductWithHalfScale = halfExpScale + doubleScaledProduct;

        uint256 product = doubleScaledProductWithHalfScale / expScale;
        return Exp({ mantissa: product });
    }

    /// @dev Multiplies three exponentials, returning a new exponential.
    function mulExp3(
        Exp memory a,
        Exp memory b,
        Exp memory c
    ) internal pure returns (Exp memory) {
        Exp memory ab = mulExp(a, b);
        return mulExp(ab, c);
    }

    /// @dev Subtracts two exponentials, returning a new exponential.
    function subExp(Exp memory a, Exp memory b) internal pure returns (Exp memory) {
        uint256 result = a.mantissa - b.mantissa;
        return Exp({ mantissa: result });
    }
}
