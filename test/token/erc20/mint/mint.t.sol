// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { stdError } from "forge-std/Test.sol";

import { ERC20Test } from "../ERC20Test.t.sol";

contract ERC20__Mint is ERC20Test {
    /// @dev it should revert.
    function testCannotMint__BeneficiaryZeroAddress() external {
        address beneficiary = address(0);
        vm.expectRevert(IERC20.ERC20__MintBeneficiaryZeroAddress.selector);
        uint256 amount = 1;
        dai.mint(beneficiary, amount);
    }

    modifier BeneficiaryNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testCannotMint__BeneficiaryBalanceCalculationOverflowsUint256(
        address beneficiary,
        uint256 amount0,
        uint256 amount1
    ) external BeneficiaryNotZeroAddress {
        vm.assume(beneficiary != address(0));
        vm.assume(amount0 > 0);
        vm.assume(amount1 > MAX_UINT256 - amount0);

        // Mint `amount0` tokens to `beneficiary`.
        dai.mint(beneficiary, amount0);

        // Run the test.
        vm.expectRevert(stdError.arithmeticError);
        dai.mint(beneficiary, amount1);
    }

    modifier BeneficiaryBalanceCalculationDoesNotOverflowUint256() {
        _;
    }

    /// @dev it should revert.
    function testCannotMint__TotalSupplyCalculationOverflowsUint256(
        address beneficiary,
        uint256 amount0,
        uint256 amount1
    ) external BeneficiaryNotZeroAddress BeneficiaryBalanceCalculationDoesNotOverflowUint256 {
        vm.assume(beneficiary != address(0));
        vm.assume(amount0 > 0);
        vm.assume(amount1 > MAX_UINT256 - amount0);

        // Mint `amount0` tokens to Alice.
        dai.mint(users.alice, amount0);

        // Run the test.
        vm.expectRevert(stdError.arithmeticError);
        dai.mint(beneficiary, amount1);
    }

    modifier TotalSupplyCalculationDoesNotOverflowUint256() {
        _;
    }

    /// @dev it should increase the balance of the beneficiary.
    function testMint__IncreaseBeneficiaryBalance(address beneficiary, uint256 amount)
        external
        BeneficiaryNotZeroAddress
        BeneficiaryBalanceCalculationDoesNotOverflowUint256
        TotalSupplyCalculationDoesNotOverflowUint256
    {
        vm.assume(beneficiary != address(0));
        vm.assume(amount > 0);

        uint256 previousBalance = dai.balanceOf(beneficiary);
        dai.mint(beneficiary, amount);
        uint256 actualBalance = dai.balanceOf(beneficiary);
        uint256 expectedBalance = previousBalance + amount;
        assertEq(actualBalance, expectedBalance);
    }

    /// @dev it should increase the total supply.
    function testMint__IncreaseTotalSupply(address beneficiary, uint256 amount)
        external
        BeneficiaryNotZeroAddress
        BeneficiaryBalanceCalculationDoesNotOverflowUint256
        TotalSupplyCalculationDoesNotOverflowUint256
    {
        vm.assume(beneficiary != address(0));
        vm.assume(amount > 0);

        uint256 previousTotalSupply = dai.totalSupply();
        dai.mint(beneficiary, amount);
        uint256 actualTotalSupply = dai.totalSupply();
        uint256 expectedTotalSupply = previousTotalSupply + amount;
        assertEq(actualTotalSupply, expectedTotalSupply);
    }

    /// @dev it should emit a Transfer event.
    function testMint__Event(address beneficiary, uint256 amount)
        external
        BeneficiaryNotZeroAddress
        BeneficiaryBalanceCalculationDoesNotOverflowUint256
        TotalSupplyCalculationDoesNotOverflowUint256
    {
        vm.assume(beneficiary != address(0));
        vm.assume(amount > 0);

        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), beneficiary, amount);
        dai.mint(beneficiary, amount);
    }
}
