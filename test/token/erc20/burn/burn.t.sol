// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { stdError } from "forge-std/StdError.sol";

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20_Test } from "../ERC20.t.sol";

contract Burn_Test is ERC20_Test {
    /// @dev it should revert.
    function test_RevertWhen_HolderZeroAddress() external {
        vm.expectRevert(IERC20.ERC20_BurnHolderZeroAddress.selector);
        dai.burn({ holder: address(0), amount: 1 });
    }

    modifier holderNotZeroAddress() {
        _;
    }

    /// @dev it should revert.
    function testFuzz_RevertWhen_HolderBalanceCalculationUnderflowsUint256(
        address holder,
        uint256 amount
    ) external holderNotZeroAddress {
        vm.assume(holder != address(0));
        vm.assume(amount > 0);

        // Expect an arithmetic error.
        vm.expectRevert(stdError.arithmeticError);

        // Burn the tokens.
        dai.burn(holder, amount);
    }

    modifier holderBalanceCalculationDoesNotUnderflowUint256() {
        _;
    }

    /// @dev Checks common assumptions for the tests below.
    function checkAssumptions(address holder, uint256 burnAmount) internal pure {
        vm.assume(holder != address(0));
        vm.assume(burnAmount > 0 && burnAmount < MAX_UINT256);
    }

    /// @dev it should decrease the balance of the holder.
    function testFuzz_Burn_DecreaseHolderBalance(
        address holder,
        uint256 mintAmount,
        uint256 burnAmount
    ) external holderNotZeroAddress holderBalanceCalculationDoesNotUnderflowUint256 {
        checkAssumptions(holder, burnAmount);
        mintAmount = bound(mintAmount, burnAmount + 1, MAX_UINT256);

        // Mint `mintAmount` tokens to `holder` so that we have what to burn below.
        dai.mint(holder, mintAmount);

        // Burn the tokens.
        dai.burn(holder, burnAmount);

        // Assert that the balance of the holder has decreased.
        uint256 actualBalance = dai.balanceOf(holder);
        uint256 expectedBalance = mintAmount - burnAmount;
        assertEq(actualBalance, expectedBalance, "balance");
    }

    /// @dev it should decrease the total supply and emit a {Transfer} event.
    function testFuzz_Burn_DecreaseTotalSupply(
        address holder,
        uint256 mintAmount,
        uint256 burnAmount
    ) external holderNotZeroAddress holderBalanceCalculationDoesNotUnderflowUint256 {
        checkAssumptions(holder, burnAmount);
        mintAmount = bound(mintAmount, burnAmount + 1, MAX_UINT256);

        // Mint `mintAmount` tokens to `holder` so that we have what to burn below.
        dai.mint(holder, mintAmount);

        // Load the initial total supply.
        uint256 initialTotalSupply = dai.totalSupply();

        // Burn the tokens.
        dai.burn(holder, burnAmount);

        // Assert that the total supply has decreased.
        uint256 actualTotalSupply = dai.totalSupply();
        uint256 expectedTotalSupply = initialTotalSupply - burnAmount;
        assertEq(actualTotalSupply, expectedTotalSupply, "totalSupply");
    }

    /// @dev it should emit a {Transfer} event.
    function testFuzz_Burn_Event(
        address holder,
        uint256 mintAmount,
        uint256 burnAmount
    ) external holderNotZeroAddress holderBalanceCalculationDoesNotUnderflowUint256 {
        checkAssumptions(holder, burnAmount);
        mintAmount = bound(mintAmount, burnAmount + 1, MAX_UINT256);

        // Mint `mintAmount` tokens to `holder` so that we have what to burn below.
        dai.mint(holder, mintAmount);

        // Expect a {Transfer} event to be emitted.
        expectEmit();
        emit Transfer({ from: holder, to: address(0), amount: burnAmount });

        // Burn the tokens.
        dai.burn(holder, burnAmount);
    }
}
