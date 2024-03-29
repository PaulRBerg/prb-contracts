// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { stdError } from "forge-std/StdError.sol";

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20_Test } from "../ERC20.t.sol";

contract Mint_Test is ERC20_Test {
    function test_RevertWhen_BeneficiaryZeroAddress() external {
        vm.expectRevert(IERC20.ERC20_MintBeneficiaryZeroAddress.selector);
        dai.mint({ beneficiary: address(0), amount: 1 });
    }

    modifier whenBeneficiaryNotZeroAddress() {
        _;
    }

    /// @dev Checks common assumptions for the tests below.
    function checkAssumptions(address beneficiary, uint256 amount0) internal pure {
        vm.assume(beneficiary != address(0));
        vm.assume(amount0 > 0);
    }

    function testFuzz_RevertWhen_BeneficiaryBalanceCalculationOverflowsUint256(
        address beneficiary,
        uint256 amount0,
        uint256 amount1
    )
        external
        whenBeneficiaryNotZeroAddress
    {
        checkAssumptions(beneficiary, amount0);
        amount1 = _bound(amount1, MAX_UINT256 - amount0 + 1, MAX_UINT256);

        // Mint `amount0` tokens to `beneficiary`.
        dai.mint(beneficiary, amount0);

        // Expect an arithmetic error.
        vm.expectRevert(stdError.arithmeticError);

        // Mint the tokens.
        dai.mint(beneficiary, amount1);
    }

    modifier whenBeneficiaryBalanceCalculationDoesNotOverflowUint256() {
        _;
    }

    function testFuzz_RevertWhen_TotalSupplyCalculationOverflowsUint256(
        address beneficiary,
        uint256 amount0,
        uint256 amount1
    )
        external
        whenBeneficiaryNotZeroAddress
        whenBeneficiaryBalanceCalculationDoesNotOverflowUint256
    {
        checkAssumptions(beneficiary, amount0);
        amount1 = _bound(amount1, MAX_UINT256 - amount0 + 1, MAX_UINT256);

        // Mint `amount0` tokens to Alice.
        dai.mint(users.alice, amount0);

        // Expect an arithmetic panic.
        vm.expectRevert(stdError.arithmeticError);

        // Mint the tokens.
        dai.mint(beneficiary, amount1);
    }

    modifier whenTotalSupplyCalculationDoesNotOverflowUint256() {
        _;
    }

    function testFuzz_Mint_IncreaseBeneficiaryBalance(
        address beneficiary,
        uint256 amount
    )
        external
        whenBeneficiaryNotZeroAddress
        whenBeneficiaryBalanceCalculationDoesNotOverflowUint256
        whenTotalSupplyCalculationDoesNotOverflowUint256
    {
        checkAssumptions(beneficiary, amount);

        // Load the initial balance.
        uint256 initialBalance = dai.balanceOf(beneficiary);

        // Mint the tokens.
        dai.mint(beneficiary, amount);

        // Assert that the balance has increased.
        uint256 actualBalance = dai.balanceOf(beneficiary);
        uint256 expectedBalance = initialBalance + amount;
        assertEq(actualBalance, expectedBalance, "balance");
    }

    function testFuzz_Mint_IncreaseTotalSupply(
        address beneficiary,
        uint256 amount
    )
        external
        whenBeneficiaryNotZeroAddress
        whenBeneficiaryBalanceCalculationDoesNotOverflowUint256
        whenTotalSupplyCalculationDoesNotOverflowUint256
    {
        checkAssumptions(beneficiary, amount);

        // Load the initial total supply.
        uint256 initialTotalSupply = dai.totalSupply();

        // Mint the tokens.
        dai.mint(beneficiary, amount);

        // Assert that the total supply has increased.
        uint256 actualTotalSupply = dai.totalSupply();
        uint256 expectedTotalSupply = initialTotalSupply + amount;
        assertEq(actualTotalSupply, expectedTotalSupply, "totalSupply");
    }

    function testFuzz_Mint_Event(
        address beneficiary,
        uint256 amount
    )
        external
        whenBeneficiaryNotZeroAddress
        whenBeneficiaryBalanceCalculationDoesNotOverflowUint256
        whenTotalSupplyCalculationDoesNotOverflowUint256
    {
        checkAssumptions(beneficiary, amount);

        // Expect a {Transfer} event to be emitted.
        vm.expectEmit({ emitter: address(dai) });
        emit Transfer({ from: address(0), to: beneficiary, amount: amount });

        // Mint the tokens.
        dai.mint(beneficiary, amount);
    }
}
