// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";
import { ERC20GodMode } from "@prb/contracts/token/erc20/ERC20GodMode.sol";
import { ERC20Normalizer } from "@prb/contracts/token/erc20/ERC20Normalizer.sol";
import { IERC20Normalizer } from "@prb/contracts/token/erc20/IERC20Normalizer.sol";

import { ERC20NormalizerUnitTest } from "../ERC20NormalizerUnitTest.t.sol";

contract ERC20Normalizer__Denormalize__ScalarNotComputed is ERC20NormalizerUnitTest {
    /// @dev it should return the denormalized amount.
    function testDenormalize() external {
        uint256 amount = bn(100, STANDARD_DECIMALS);
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = bn(100, usdc.decimals());
        assertEq(expectedDenormalizedAmount, actualDenormalizedAmount);
    }
}

contract ScalarComputed is ERC20NormalizerUnitTest {
    /// @dev A setup function invoked before each test case.
    function setUp() public override {
        super.setUp();
        erc20Normalizer.computeScalar(usdc);
    }
}

contract ERC20Normalizer__Denormalize__Scalar1 is ScalarComputed {
    /// @dev it should return the denormalized amount.
    function testDenormalize() external {
        uint256 amount = bn(100, STANDARD_DECIMALS);
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = bn(100, usdc.decimals());
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }
}

contract ScalarNot1 {}

contract ERC20Normalizer__Denormalize__AmountZero is ScalarComputed, ScalarNot1 {
    /// @dev it should return zero.
    function testDenormalize__A() external {
        uint256 amount = 0;
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = 0;
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }
}

contract AmountNotZero {}

contract ERC20Normalizer__Denormalize__AmountSmallerThanScalar is ScalarComputed, ScalarNot1, AmountNotZero {
    /// @dev it should return zero.
    function testDenormalize__AmountSmallerThanScalar() external {
        uint256 amount = USDC_SCALAR - 1;
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = 0;
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }
}

contract ERC20Normalizer__Denormalize__AmountEqualToScalar is ScalarComputed, ScalarNot1, AmountNotZero {
    /// @dev it should return one.
    function testDenormalize__AmountEqualToScalar() external {
        uint256 amount = USDC_SCALAR;
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount = 1;
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }
}

contract ERC20Normalizer__Denormalize__AmountBiggerThanScalar is ScalarComputed, ScalarNot1, AmountNotZero {
    /// @dev it should return the denormalized amount.
    function testDenormalize__AmountBiggerThanScalar(uint256 amount) external {
        vm.assume(amount > USDC_SCALAR);
        uint256 actualDenormalizedAmount = erc20Normalizer.denormalize(usdc, amount);
        uint256 expectedDenormalizedAmount;
        unchecked {
            expectedDenormalizedAmount = amount / USDC_SCALAR;
        }
        assertEq(actualDenormalizedAmount, expectedDenormalizedAmount);
    }
}
