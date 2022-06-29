// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { stdError } from "forge-std/Test.sol";

import { ERC20UnitTest } from "../ERC20UnitTest.t.sol";

contract ERC20__Mint__BeneficiaryZeroAddress is ERC20UnitTest {
    /// @dev it should revert.
    function testCannotMint() external {
        address beneficiary = address(0);
        vm.expectRevert(IERC20.ERC20__MintBeneficiaryZeroAddress.selector);
        uint256 amount = 1;
        dai.mint(beneficiary, amount);
    }
}

contract BeneficiaryNotZeroAddress {}

contract ERC20__Mint__BeneficiaryBalanceCalculationOverflowsUint256 is ERC20UnitTest, BeneficiaryNotZeroAddress {
    /// @dev it should revert.
    function testCannotMint(
        address beneficiary,
        uint256 amount0,
        uint256 amount1
    ) external {
        vm.assume(beneficiary != address(0));
        vm.assume(amount0 > 0);
        vm.assume(amount1 > MAX_UINT256 - amount0);

        // Mint `amount0` tokens to `beneficiary`.
        dai.mint(beneficiary, amount0);

        // Run the test.
        vm.expectRevert(stdError.arithmeticError);
        dai.mint(beneficiary, amount1);
    }
}

contract BeneficiaryBalanceCalculationDoesNotOverflowUint256 {}

contract ERC20__Mint__TotalSupplyCalculationOverflowsUint256 is
    ERC20UnitTest,
    BeneficiaryNotZeroAddress,
    BeneficiaryBalanceCalculationDoesNotOverflowUint256
{
    /// @dev it should revert.
    function testCannotMint(
        address beneficiary,
        uint256 amount0,
        uint256 amount1
    ) external {
        vm.assume(beneficiary != address(0));
        vm.assume(amount0 > 0);
        vm.assume(amount1 > MAX_UINT256 - amount0);

        // Mint `amount0` tokens to Alice.
        dai.mint(users.alice, amount0);

        // Run the test.
        vm.expectRevert(stdError.arithmeticError);
        dai.mint(beneficiary, amount1);
    }
}

contract TotalSupplyCalculationDoesNotOverflowUint256 {}

contract ERC20__Mint is
    ERC20UnitTest,
    BeneficiaryNotZeroAddress,
    BeneficiaryBalanceCalculationDoesNotOverflowUint256,
    TotalSupplyCalculationDoesNotOverflowUint256
{
    /// @dev it should increase the balance of the beneficiary.
    function testMint__IncreaseBeneficiaryBalance(address beneficiary, uint256 amount) external {
        vm.assume(beneficiary != address(0));
        vm.assume(amount > 0);

        uint256 previousBalance = dai.balanceOf(beneficiary);
        dai.mint(beneficiary, amount);
        uint256 actualBalance = dai.balanceOf(beneficiary);
        uint256 expectedBalance = previousBalance + amount;
        assertEq(actualBalance, expectedBalance);
    }

    /// @dev it should increase the total supply.
    function testMint__IncreaseTotalSupply(address beneficiary, uint256 amount) external {
        vm.assume(beneficiary != address(0));
        vm.assume(amount > 0);

        uint256 previousTotalSupply = dai.totalSupply();
        dai.mint(beneficiary, amount);
        uint256 actualTotalSupply = dai.totalSupply();
        uint256 expectedTotalSupply = previousTotalSupply + amount;
        assertEq(actualTotalSupply, expectedTotalSupply);
    }

    /// @dev it should emit a Transfer event.
    function testMint__Event(address beneficiary, uint256 amount) external {
        vm.assume(beneficiary != address(0));
        vm.assume(amount > 0);

        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), beneficiary, amount);
        dai.mint(beneficiary, amount);
    }
}
