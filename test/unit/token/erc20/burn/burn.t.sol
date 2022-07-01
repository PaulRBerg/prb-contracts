// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { stdError } from "forge-std/Test.sol";

import { ERC20UnitTest } from "../ERC20UnitTest.t.sol";

contract ERC20__Burn__BeneficiaryZeroAddress is ERC20UnitTest {
    /// @dev it should revert.
    function testCannotBurn() external {
        address holder = address(0);
        vm.expectRevert(IERC20.ERC20__BurnHolderZeroAddress.selector);
        uint256 amount = 1;
        dai.burn(holder, amount);
    }
}

contract HolderNotZeroAddress {}

contract ERC20__Burn__HolderBalanceCalculationUnderflowsUint256 is ERC20UnitTest, HolderNotZeroAddress {
    /// @dev it should revert.
    function testCannotBurn(address holder, uint256 amount) external {
        vm.assume(holder != address(0));
        vm.assume(amount > 0);

        vm.expectRevert(stdError.arithmeticError);
        dai.burn(holder, amount);
    }
}

contract HolderBalanceCalculationDoesNotUnderflowUint256 {}

contract ERC20__Burn is ERC20UnitTest, HolderNotZeroAddress, HolderBalanceCalculationDoesNotUnderflowUint256 {
    /// @dev it should decrease the balance of the holder.
    function testBurn__DecreaseHolderBalance(
        address holder,
        uint256 mintAmount,
        uint256 burnAmount
    ) external {
        vm.assume(holder != address(0));
        vm.assume(mintAmount > 0);
        vm.assume(burnAmount > 0);
        vm.assume(mintAmount > burnAmount);

        // Mint `mintAmount` tokens to `holder` so that we have what to burn below.
        dai.mint(holder, mintAmount);

        // Run the test.
        dai.burn(holder, burnAmount);
        uint256 actualBalance = dai.balanceOf(holder);
        uint256 expectedBalance = mintAmount - burnAmount;
        assertEq(actualBalance, expectedBalance);
    }

    /// @dev it should decrease the total supply.
    function testBurn__IncreaseTotalSupply(
        address holder,
        uint256 mintAmount,
        uint256 burnAmount
    ) external {
        vm.assume(holder != address(0));
        vm.assume(mintAmount > 0);
        vm.assume(burnAmount > 0);
        vm.assume(mintAmount > burnAmount);

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
    function testBurn__Event(
        address holder,
        uint256 mintAmount,
        uint256 burnAmount
    ) external {
        vm.assume(holder != address(0));
        vm.assume(mintAmount > 0);
        vm.assume(burnAmount > 0);
        vm.assume(mintAmount > burnAmount);

        // Mint `mintAmount` tokens to `holder` so that we have what to burn below.
        dai.mint(holder, mintAmount);

        // Run the test.
        vm.expectEmit(true, true, false, true);
        emit Transfer(holder, address(0), burnAmount);
        dai.burn(holder, burnAmount);
    }
}