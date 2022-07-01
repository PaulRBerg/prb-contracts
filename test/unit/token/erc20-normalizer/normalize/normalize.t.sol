// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";
import { ERC20GodMode } from "@prb/contracts/token/erc20/ERC20GodMode.sol";
import { ERC20Normalizer } from "@prb/contracts/token/erc20/ERC20Normalizer.sol";
import { IERC20Normalizer } from "@prb/contracts/token/erc20/IERC20Normalizer.sol";

import { stdError } from "forge-std/Test.sol";

import { ERC20NormalizerUnitTest } from "../ERC20NormalizerUnitTest.t.sol";

contract ERC20Normalizer__Normalize__ScalarNotComputed is ERC20NormalizerUnitTest {
    /// @dev it should return the normalized amount.
    function testNormalize__ScalarNotComputed() external {
        uint256 amount = bn(100, usdc.decimals());
        uint256 actualNormalizedAmount = erc20Normalizer.normalize(usdc, amount);
        uint256 expectedNormalizedAmount = bn(100, STANDARD_DECIMALS);
        assertEq(expectedNormalizedAmount, actualNormalizedAmount);
    }
}

contract ScalarComputed is ERC20NormalizerUnitTest {
    /// @dev A setup function invoked before each test case.
    function setUp() public override {
        super.setUp();
        erc20Normalizer.computeScalar(usdc);
    }
}

contract ERC20Normalizer__Normalize__Scalar1 is ScalarComputed {
    /// @dev it should return the normalized amount.
    function testNormalize() external {
        erc20Normalizer.computeScalar(usdc);
        uint256 amount = bn(100, usdc.decimals());
        uint256 actualNormalizedAmount = erc20Normalizer.normalize(usdc, amount);
        uint256 expectedNormalizedAmount = bn(100, STANDARD_DECIMALS);
        assertEq(actualNormalizedAmount, expectedNormalizedAmount);
    }
}

contract ScalarNot1 {}

contract ERC20Normalizer__Normalize__CalculationOverflows is ScalarComputed, ScalarNot1 {
    /// @dev it should revert.
    function testCannotNormalize(uint256 amount) external {
        vm.assume(amount > (UINT256_MAX / USDC_SCALAR) + 1); // 10^12 is the scalar for USDC.
        erc20Normalizer.computeScalar(usdc);
        vm.expectRevert(stdError.arithmeticError);
        erc20Normalizer.normalize(usdc, amount);
    }
}

contract CalculationDoesNotOverflow {}

contract ERC20Normalizer__Normalize__AmountZero is ScalarComputed, ScalarNot1, CalculationDoesNotOverflow {
    /// @dev it should return zero.
    function testNormalize__AmountZero() external {
        erc20Normalizer.computeScalar(usdc);
        uint256 amount = 0;
        uint256 actualNormalizedAmount = erc20Normalizer.normalize(usdc, amount);
        uint256 expectedNormalizedAmount = 0;
        assertEq(actualNormalizedAmount, expectedNormalizedAmount);
    }
}

contract AmountNotZero {}

contract ERC20Normalizer__Normalize is ScalarComputed, ScalarNot1, CalculationDoesNotOverflow, AmountNotZero {
    /// @dev it should return the normalized amount.
    function testNormalize(uint256 amount) external {
        vm.assume(amount > 0);
        vm.assume(amount <= UINT256_MAX / USDC_SCALAR); // 10^12 is the scalar for USDC.
        erc20Normalizer.computeScalar(usdc);
        uint256 actualNormalizedAmount = erc20Normalizer.normalize(usdc, amount);
        uint256 expectedNormalizedAmount;
        unchecked {
            expectedNormalizedAmount = amount * USDC_SCALAR;
        }
        assertEq(actualNormalizedAmount, expectedNormalizedAmount);
    }
}
