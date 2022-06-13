// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";
import { ERC20GodMode } from "@prb/contracts/token/erc20/ERC20GodMode.sol";
import { ERC20Normalizer } from "@prb/contracts/token/erc20/ERC20Normalizer.sol";
import { IERC20Normalizer } from "@prb/contracts/token/erc20/IERC20Normalizer.sol";

import { ERC20NormalizerUnitTest } from "../ERC20NormalizerUnitTest.t.sol";

contract ERC20Normalizer__Denormalize__UnitTest is ERC20NormalizerUnitTest {
    /// @dev When the scalar has not been computed, it should return the denormalized amount.
    function testDenormalize__ScalarNotComputed() external {
        uint256 amount = bn(100, STANDARD_DECIMALS);
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = bn(100, usdc.decimals());
        assertEq(expectedDenormalizedAmount, actualDenormalizedAmount);
    }

    /// @dev When the scalar is 1, it should return the denormalized amount.
    function testDenormalize__Scalar1() external {
        erc20Normalizer.computeScalar(usdc);
        uint256 amount = bn(100, STANDARD_DECIMALS);
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = bn(100, usdc.decimals());
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }

    /// @dev When the amount is zero, it should return zero.
    function testDenormalize__AmountZero() external {
        erc20Normalizer.computeScalar(usdc);
        uint256 amount = 0;
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = 0;
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }

    /// @dev When the amount is smaller than the scalar, it should return zero.
    function testDenormalize__AmountSmallerThanScalar() external {
        erc20Normalizer.computeScalar(usdc);
        uint256 amount = USDC_SCALAR - 1;
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = 0;
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }

    /// @dev When the amount is equal to the scalar, it should return one.
    function testDenormalize__AmountEqualToScalar() external {
        erc20Normalizer.computeScalar(usdc);
        uint256 amount = USDC_SCALAR;
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = 1;
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }

    /// @dev When the amount is bigger than the scalar, it should return the denormalized amount.
    function testDenormalize__AmountBiggerThanScalar(uint256 amount) external {
        vm.assume(amount > USDC_SCALAR);
        erc20Normalizer.computeScalar(usdc);
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount;
        unchecked {
            expectedDenormalizedAmount = amount / USDC_SCALAR;
        }
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }
}
