// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { Base_Test } from "../../Base.t.sol";

/// @notice Common logic needed by all {ERC20} tests.
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
