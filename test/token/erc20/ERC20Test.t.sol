// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20 } from "@prb/contracts/token/erc20/ERC20.sol";

import { BaseTest } from "../../BaseTest.t.sol";

/// @title ERC20Test
/// @author Paul Razvan Berg
/// @notice Common contract members needed across ERC20 test contracts.
abstract contract ERC20Test is BaseTest {
    /// EVENTS ///

    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /// CONSTANTS ///

    uint256 internal TRANSFER_AMOUNT = bn(100, 18);

    /// SETUP FUNCTION ///

    /// @dev A setup function invoked before each test case.
    function setUp() public virtual override {
        super.setUp();

        // Burn the $DAI tokens that all users have so that their balance do not interfere with the tests.
        dai.burn(users.alice, ONE_MILLION_DAI);
        dai.burn(users.bob, ONE_MILLION_DAI);
        dai.burn(users.eve, ONE_MILLION_DAI);
    }
}
