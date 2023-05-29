// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { Adminable } from "src/access/Adminable.sol";
import { IAdminable } from "src/access/IAdminable.sol";

import { Base_Test } from "../../Base.t.sol";

/// @notice Common logic needed by all ERC20Recover unit tests.
abstract contract AdminableTest is Base_Test {
    /*//////////////////////////////////////////////////////////////////////////
                                       EVENTS
    //////////////////////////////////////////////////////////////////////////*/

    event TransferAdmin(address indexed oldAdmin, address indexed newAdmin);

    /*//////////////////////////////////////////////////////////////////////////
                                   TEST CONTRACTS
    //////////////////////////////////////////////////////////////////////////*/

    IAdminable internal adminable;

    /*//////////////////////////////////////////////////////////////////////////
                                   SETUP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev A setup function invoked before each test case.
    function setUp() public virtual override {
        Base_Test.setUp();
        adminable = new Adminable();
    }
}
