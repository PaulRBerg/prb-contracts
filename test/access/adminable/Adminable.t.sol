// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { Adminable } from "src/access/Adminable.sol";
import { IAdminable } from "src/access/IAdminable.sol";

import { BaseTest } from "../../BaseTest.t.sol";

/// @title ERC20RecoverTest
/// @notice Common contract members needed across ERC20Recover test contracts.
abstract contract AdminableTest is BaseTest {
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
        BaseTest.setUp();
        adminable = new Adminable();
    }
}
