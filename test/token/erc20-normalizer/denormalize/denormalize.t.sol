// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { IERC20 } from "src/token/erc20/IERC20.sol";
import { ERC20GodMode } from "src/token/erc20/ERC20GodMode.sol";
import { ERC20Normalizer } from "src/token/erc20/ERC20Normalizer.sol";
import { IERC20Normalizer } from "src/token/erc20/IERC20Normalizer.sol";

import { ERC20Normalizer_Test } from "../ERC20Normalizer.t.sol";

contract Denormalize_Test is ERC20Normalizer_Test {
    function test_Denormalize_ScalarNotComputed() external {
        uint256 amount = bn(100, STANDARD_DECIMALS);
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize({ token: usdc, amount: amount });
        uint256 expectedDenormalizedAmount = bn(100, usdc.decimals());
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount, "normalizedAmount");
    }

    modifier whenScalarComputed() {
        _;
    }

    function test_Denormalize_Scalar1() external whenScalarComputed {
        erc20Normalizer.computeScalar({ token: usdc });
        uint256 amount = bn(100, STANDARD_DECIMALS);
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize({ token: usdc, amount: amount });
        uint256 expectedDenormalizedAmount = bn(100, usdc.decimals());
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount, "normalizedAmount");
    }

    modifier whenScalarNot1() {
        _;
    }

    function test_Denormalize_AmountZero() external whenScalarComputed whenScalarNot1 {
        erc20Normalizer.computeScalar({ token: usdc });
        uint256 amount = 0;
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize({ token: usdc, amount: amount });
        uint256 expectedDenormalizedAmount = 0;
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount, "normalizedAmount");
    }

    modifier whenAmountNotZero() {
        _;
    }

    function test_Denormalize_AmountSmallerThanScalar() external whenScalarComputed whenScalarNot1 whenAmountNotZero {
        erc20Normalizer.computeScalar({ token: usdc });
        uint256 amount = USDC_SCALAR - 1;
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize({ token: usdc, amount: amount });
        uint256 expectedDenormalizedAmount = 0;
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount, "normalizedAmount");
    }

    function testFuzz_Denormalize_AmountBiggerThanScalar(uint256 amount)
        external
        whenScalarComputed
        whenScalarNot1
        whenAmountNotZero
    {
        erc20Normalizer.computeScalar({ token: usdc });
        amount = bound(amount, USDC_SCALAR + 1, MAX_UINT256);

        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize({ token: usdc, amount: amount });
        uint256 expectedDenormalizedAmount;
        unchecked {
            expectedDenormalizedAmount = amount / USDC_SCALAR;
        }
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount, "normalizedAmount");
    }
}
