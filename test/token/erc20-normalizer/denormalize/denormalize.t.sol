// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "src/token/erc20/IERC20.sol";
import { ERC20GodMode } from "src/token/erc20/ERC20GodMode.sol";
import { ERC20Normalizer } from "src/token/erc20/ERC20Normalizer.sol";
import { IERC20Normalizer } from "src/token/erc20/IERC20Normalizer.sol";

import { ERC20NormalizerTest } from "../ERC20Normalizer.t.sol";

contract ERC20Normalizer__Denormalize is ERC20NormalizerTest {
    /// @dev it should return the denormalized amount.
    function testDenormalize__ScalarNotComputed() external {
        uint256 amount = bn(100, STANDARD_DECIMALS);
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = bn(100, usdc.decimals());
        assertEq(expectedDenormalizedAmount, actualDenormalizedAmount);
    }

    modifier ScalarComputed() {
        _;
    }

    /// @dev it should return the denormalized amount.
    function testDenormalize__Scalar1() external ScalarComputed {
        erc20Normalizer.computeScalar(usdc);
        uint256 amount = bn(100, STANDARD_DECIMALS);
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = bn(100, usdc.decimals());
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }

    modifier ScalarNot1() {
        _;
    }

    /// @dev it should return zero.
    function testDenormalize__AmountZero() external ScalarComputed ScalarNot1 {
        erc20Normalizer.computeScalar(usdc);
        uint256 amount = 0;
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = 0;
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }

    modifier AmountNotZero() {
        _;
    }

    /// @dev it should return zero.
    function testDenormalize__AmountSmallerThanScalar() external ScalarComputed ScalarNot1 AmountNotZero {
        erc20Normalizer.computeScalar(usdc);
        uint256 amount = USDC_SCALAR - 1;
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = 0;
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }

    /// @dev it should return the denormalized amount.
    function testDenormalize__AmountBiggerThanScalar(uint256 amount) external ScalarComputed ScalarNot1 AmountNotZero {
        erc20Normalizer.computeScalar(usdc);
        vm.assume(amount > USDC_SCALAR);
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount;
        unchecked {
            expectedDenormalizedAmount = amount / USDC_SCALAR;
        }
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }
}
