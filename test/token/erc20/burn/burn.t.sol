// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { stdError } from "forge-std/Test.sol";

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20Test } from "../ERC20.t.sol";

contract Burn_Test is ERC20Test {
    /// @dev it should revert.
    function test_RevertWhen_HolderZeroAddress() external {
        address holder = address(0);
        vm.expectRevert(IERC20.ERC20_BurnHolderZeroAddress.selector);
        uint256 amount = 1;
        dai.burn(holder, amount);
    }

    modifier HolderNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testFuzz_RevertWhen_HolderBalanceCalculationUnderflowsUint256(address holder, uint256 amount)
        external
        HolderNotZeroAddress
    {
        vm.assume(holder != address(0));
        vm.assume(amount > 0);

        vm.expectRevert(stdError.arithmeticError);
        dai.burn(holder, amount);
    }

    modifier HolderBalanceCalculationDoesNotUnderflowUint256() {
        _;
    }

    /// @dev Checks common assumptions for the tests below.
    function checkAssumptions(
        address holder,
        uint256 mintAmount,
        uint256 burnAmount
    ) internal pure {
        vm.assume(holder != address(0));
        vm.assume(mintAmount > 0 && burnAmount > 0);
        vm.assume(mintAmount > burnAmount);
    }

    /// @dev it should decrease the balance of the holder.
    function testFuzz_Burn_DecreaseHolderBalance(
        address holder,
        uint256 mintAmount,
        uint256 burnAmount
    ) external HolderNotZeroAddress HolderBalanceCalculationDoesNotUnderflowUint256 {
        checkAssumptions(holder, mintAmount, burnAmount);

        // Mint `mintAmount` tokens to `holder` so that we have what to burn below.
        dai.mint(holder, mintAmount);

        // Assert that the
        dai.burn(holder, burnAmount);
        uint256 actualBalance = dai.balanceOf(holder);
        uint256 expectedBalance = mintAmount - burnAmount;
        assertEq(actualBalance, expectedBalance);
    }

    /// @dev it should decrease the total supply.
    function testFuzz_Burn_DecreaseTotalSupply(
        address holder,
        uint256 mintAmount,
        uint256 burnAmount
    ) external HolderNotZeroAddress HolderBalanceCalculationDoesNotUnderflowUint256 {
        checkAssumptions(holder, mintAmount, burnAmount);

        // Mint `mintAmount` tokens to `holder` so that we have what to burn below.
        dai.mint(holder, mintAmount);

        // Run the test.
        uint256 previousTotalSupply = dai.totalSupply();
        dai.burn(holder, burnAmount);
        uint256 actualTotalSupply = dai.totalSupply();
        uint256 expectedTotalSupply = previousTotalSupply - burnAmount;
        assertEq(actualTotalSupply, expectedTotalSupply);
    }

    /// @dev it should emit a Transfer event.
    function testFuzz_Burn_Event(
        address holder,
        uint256 mintAmount,
        uint256 burnAmount
    ) external HolderNotZeroAddress HolderBalanceCalculationDoesNotUnderflowUint256 {
        checkAssumptions(holder, mintAmount, burnAmount);

        // Mint `mintAmount` tokens to `holder` so that we have what to burn below.
        dai.mint(holder, mintAmount);

        // Run the test.
        vm.expectEmit({ checkTopic1: true, checkTopic2: true, checkTopic3: false, checkData: true });
        emit Transfer(holder, address(0), burnAmount);
        dai.burn(holder, burnAmount);
    }
}
