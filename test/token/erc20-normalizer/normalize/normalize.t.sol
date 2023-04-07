// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { IERC20 } from "src/token/erc20/IERC20.sol";
import { ERC20GodMode } from "src/token/erc20/ERC20GodMode.sol";
import { ERC20Normalizer } from "src/token/erc20/ERC20Normalizer.sol";
import { IERC20Normalizer } from "src/token/erc20/IERC20Normalizer.sol";

import { stdError } from "forge-std/StdError.sol";

import { ERC20Normalizer_Test } from "../ERC20Normalizer.t.sol";

contract Normalize_Test is ERC20Normalizer_Test {
    /// @dev it should return the normalized amount.
    function test_Normalize_ScalarNotComputed() external {
        uint256 amount = bn(100, usdc.decimals());
        uint256 actualNormalizedAmount = erc20Normalizer.normalize({ token: usdc, amount: amount });
        uint256 expectedNormalizedAmount = bn(100, STANDARD_DECIMALS);
        assertEq(actualNormalizedAmount, expectedNormalizedAmount, "normalizedAmount");
    }

    modifier whenScalarComputed() {
        _;
    }

    /// @dev it should return the normalized amount.
    function test_Normalize_Scalar1() external whenScalarComputed {
        erc20Normalizer.computeScalar({ token: usdc });
        uint256 amount = bn(100, usdc.decimals());
        uint256 actualNormalizedAmount = erc20Normalizer.normalize({ token: usdc, amount: amount });
        uint256 expectedNormalizedAmount = bn(100, STANDARD_DECIMALS);
        assertEq(actualNormalizedAmount, expectedNormalizedAmount, "normalizedAmount");
    }

    modifier whenScalarNot1() {
        _;
    }

    /// @dev it should revert.
    function testFuzz_RevertWhen_CalculationOverflows(uint256 amount) external whenScalarComputed whenScalarNot1 {
        vm.assume(amount > (MAX_UINT256 / USDC_SCALAR) + 1); // 10^12 is the scalar for USDC.
        erc20Normalizer.computeScalar({ token: usdc });
        vm.expectRevert(stdError.arithmeticError);
        erc20Normalizer.normalize({ token: usdc, amount: amount });
    }

    modifier whenCalculationDoesNotOverflow() {
        _;
    }

    /// @dev it should return zero.
    function test_Normalize_AmountZero() external whenScalarComputed whenScalarNot1 whenCalculationDoesNotOverflow {
        erc20Normalizer.computeScalar({ token: usdc });
        uint256 amount = 0;
        uint256 actualNormalizedAmount = erc20Normalizer.normalize({ token: usdc, amount: amount });
        uint256 expectedNormalizedAmount = 0;
        assertEq(actualNormalizedAmount, expectedNormalizedAmount, "normalizedAmount");
    }

    modifier whenAmountNotZero() {
        _;
    }

    /// @dev it should return the normalized amount.
    function testFuzz_Normalize(uint256 amount)
        external
        whenScalarComputed
        whenScalarNot1
        whenCalculationDoesNotOverflow
        whenAmountNotZero
    {
        amount = bound(amount, 1, MAX_UINT256 / USDC_SCALAR); // 10^12 is the scalar for USDC
        erc20Normalizer.computeScalar({ token: usdc });
        uint256 actualNormalizedAmount = erc20Normalizer.normalize({ token: usdc, amount: amount });
        uint256 expectedNormalizedAmount;
        unchecked {
            expectedNormalizedAmount = amount * USDC_SCALAR;
        }
        assertEq(actualNormalizedAmount, expectedNormalizedAmount, "normalizedAmount");
    }
}
