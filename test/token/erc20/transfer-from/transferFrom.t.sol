// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20_Test } from "../ERC20.t.sol";

contract TransferFrom_Test is ERC20_Test {
    function test_RevertWhen_SpenderAllowanceNotEnough(address owner, uint256 amount) external {
        vm.assume(owner != address(0));
        vm.assume(amount > 0);

        address spender = users.alice;
        uint256 currentAllowance = 0;
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20.ERC20_InsufficientAllowance.selector, owner, spender, currentAllowance, amount
            )
        );
        dai.transferFrom({ from: owner, to: spender, amount: amount });
    }

    modifier whenSpenderAllowanceEnough() {
        _;
    }

    function checkAssumptions(address owner, address to, uint256 amount0) internal pure {
        vm.assume(owner != address(0) && to != address(0));
        vm.assume(owner != to);
        vm.assume(amount0 > 0);
    }

    function testFuzz_TransferFrom_DecreaseOwnerBalance(
        address owner,
        address to,
        uint256 amount0,
        uint256 amount1
    )
        external
        whenSpenderAllowanceEnough
    {
        checkAssumptions(owner, to, amount0);
        amount1 = _bound(amount1, 1, amount0);

        // Mint `amount0` tokens to the owner.
        dai.mint(owner, amount0);

        // Approve Alice to spend tokens from the owner.
        changePrank(owner);
        dai.approve({ spender: users.alice, value: amount0 });

        // Make Alice the caller in this test.
        changePrank(users.alice);

        // Load the initial owner's balance.
        uint256 initialOwnerBalance = dai.balanceOf(owner);

        // Transfer the tokens.
        dai.transferFrom({ from: owner, to: to, amount: amount1 });

        // Assert that the owner's balance has decreased.
        uint256 actualOwnerBalance = dai.balanceOf(owner);
        uint256 expectedOwnerBalance = initialOwnerBalance - amount1;
        assertEq(actualOwnerBalance, expectedOwnerBalance, "owner balance");
    }

    function testFuzz_TransferFrom_IncreaseReceiverBalance(
        address owner,
        address to,
        uint256 amount0,
        uint256 amount1
    )
        external
        whenSpenderAllowanceEnough
    {
        checkAssumptions(owner, to, amount0);
        amount1 = _bound(amount1, 1, amount0);

        // Mint `amount0` tokens to the owner.
        dai.mint(owner, amount0);

        // Approve Alice to spend tokens from the owner.
        changePrank(owner);
        dai.approve({ spender: users.alice, value: amount0 });

        // Make Alice the caller in this test.
        changePrank(users.alice);

        // Load the initial receiver's balance.
        uint256 initialToBalance = dai.balanceOf(to);

        // Transfer the tokens.
        dai.transferFrom({ from: owner, to: to, amount: amount1 });

        // Assert that the receiver's balance has increased.
        uint256 actualToBalance = dai.balanceOf(to);
        uint256 expectedToBalance = initialToBalance + amount1;
        assertEq(actualToBalance, expectedToBalance, "to balance");
    }

    function testFuzz_TransferFrom_Event(
        address owner,
        address to,
        uint256 amount0,
        uint256 amount1
    )
        external
        whenSpenderAllowanceEnough
    {
        checkAssumptions(owner, to, amount0);
        amount1 = _bound(amount1, 1, amount0);

        // Mint `amount0` tokens to the owner.
        dai.mint(owner, amount0);

        // Approve Alice to spend tokens from the owner.
        changePrank(owner);
        dai.approve({ spender: users.alice, value: amount0 });

        // Make the spender the caller in this test.
        changePrank(users.alice);

        // Expect an {Approval} and a {Transfer} event to be emitted.
        vm.expectEmit({ emitter: address(dai) });
        emit Approval({ owner: owner, spender: users.alice, amount: amount0 - amount1 });
        vm.expectEmit({ emitter: address(dai) });
        emit Transfer({ from: owner, to: to, amount: amount1 });

        // Transfer the tokens.
        dai.transferFrom({ from: owner, to: to, amount: amount1 });
    }
}
