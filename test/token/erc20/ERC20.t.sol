// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { ERC20 } from "src/token/erc20/ERC20.sol";

import { Base_Test } from "../../Base.t.sol";

/// @title ERC20_Test
/// @notice Common contract members needed across {ERC20} test contracts.
abstract contract ERC20_Test is Base_Test {
    /*//////////////////////////////////////////////////////////////////////////
                                       EVENTS
    //////////////////////////////////////////////////////////////////////////*/

    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /*//////////////////////////////////////////////////////////////////////////
                                     CONSTANTS
    //////////////////////////////////////////////////////////////////////////*/

    uint256 internal constant TRANSFER_AMOUNT = 100e18;

    /*//////////////////////////////////////////////////////////////////////////
                                   SETUP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev A setup function invoked before each test case.
    function setUp() public virtual override {
        Base_Test.setUp();

        // Burn the token balances so that they do not interfere with the tests.
        dai.burn(users.alice, ONE_MILLION_DAI);
        dai.burn(users.admin, ONE_MILLION_DAI);
        dai.burn(users.bob, ONE_MILLION_DAI);
        dai.burn(users.eve, ONE_MILLION_DAI);

        // Make Alice the default caller in all subsequent tests.
        changePrank(users.alice);
    }
}
