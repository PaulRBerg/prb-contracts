// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { stdError } from "forge-std/Test.sol";

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20Test } from "../ERC20.t.sol";

contract Mint_Test is ERC20Test {
    /// @dev it should revert.
    function test_RevertWhen_BeneficiaryZeroAddress() external {
        address beneficiary = address(0);
        vm.expectRevert(IERC20.ERC20_MintBeneficiaryZeroAddress.selector);
        uint256 amount = 1;
        dai.mint(beneficiary, amount);
    }

    modifier beneficiaryNotZeroAddress() {
        _;
    }

    /// @dev Checks common assumptions for the tests below.
    function checkAssumptions(
        address beneficiary,
        uint256 amount0,
        uint256 amount1
    ) internal pure {
        vm.assume(beneficiary != address(0));
        vm.assume(amount0 > 0);
        vm.assume(amount1 > MAX_UINT256 - amount0);
    }

    /// @dev it should revert.
    function testFuzz_RevertWhen_BeneficiaryBalanceCalculationOverflowsUint256(
        address beneficiary,
        uint256 amount0,
        uint256 amount1
    ) external beneficiaryNotZeroAddress {
        checkAssumptions(beneficiary, amount0, amount1);

        // Mint `amount0` tokens to `beneficiary`.
        dai.mint(beneficiary, amount0);

        // Run the test.
        vm.expectRevert(stdError.arithmeticError);
        dai.mint(beneficiary, amount1);
    }

    modifier beneficiaryBalanceCalculationDoesNotOverflowUint256() {
        _;
    }

    /// @dev it should revert.
    function testFuzz_RevertWhen_TotalSupplyCalculationOverflowsUint256(
        address beneficiary,
        uint256 amount0,
        uint256 amount1
    ) external beneficiaryNotZeroAddress beneficiaryBalanceCalculationDoesNotOverflowUint256 {
        checkAssumptions(beneficiary, amount0, amount1);

        // Mint `amount0` tokens to Alice.
        dai.mint(users.alice, amount0);

        // Run the test.
        vm.expectRevert(stdError.arithmeticError);
        dai.mint(beneficiary, amount1);
    }

    modifier totalSupplyCalculationDoesNotOverflowUint256() {
        _;
    }

    /// @dev Checks common assumptions for the tests below.
    function checkAssumptions(address beneficiary, uint256 amount) internal pure {
        vm.assume(beneficiary != address(0));
        vm.assume(amount > 0);
    }

    /// @dev it should increase the balance of the beneficiary.
    function testFuzz_Mint_IncreaseBeneficiaryBalance(address beneficiary, uint256 amount)
        external
        beneficiaryNotZeroAddress
        beneficiaryBalanceCalculationDoesNotOverflowUint256
        totalSupplyCalculationDoesNotOverflowUint256
    {
        checkAssumptions(beneficiary, amount);

        uint256 previousBalance = dai.balanceOf(beneficiary);
        dai.mint(beneficiary, amount);
        uint256 actualBalance = dai.balanceOf(beneficiary);
        uint256 expectedBalance = previousBalance + amount;
        assertEq(actualBalance, expectedBalance);
    }

    /// @dev it should increase the total supply.
    function testFuzz_Mint_IncreaseTotalSupply(address beneficiary, uint256 amount)
        external
        beneficiaryNotZeroAddress
        beneficiaryBalanceCalculationDoesNotOverflowUint256
        totalSupplyCalculationDoesNotOverflowUint256
    {
        checkAssumptions(beneficiary, amount);

        uint256 previousTotalSupply = dai.totalSupply();
        dai.mint(beneficiary, amount);
        uint256 actualTotalSupply = dai.totalSupply();
        uint256 expectedTotalSupply = previousTotalSupply + amount;
        assertEq(actualTotalSupply, expectedTotalSupply);
    }

    /// @dev it should emit a Transfer event.
    function testFuzz_Mint_Event(address beneficiary, uint256 amount)
        external
        beneficiaryNotZeroAddress
        beneficiaryBalanceCalculationDoesNotOverflowUint256
        totalSupplyCalculationDoesNotOverflowUint256
    {
        checkAssumptions(beneficiary, amount);

        vm.expectEmit({ checkTopic1: true, checkTopic2: true, checkTopic3: false, checkData: true });
        emit Transfer(address(0), beneficiary, amount);
        dai.mint(beneficiary, amount);
    }
}
