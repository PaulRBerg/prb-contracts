// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IAdminable } from "@prb/contracts/access/IAdminable.sol";

import { AdminableTest } from "../Adminable.t.sol";

contract TransferAdmin__Test is AdminableTest {
    /// @dev it should revert.
    function testCannotTransferAdmin__CallerNotAdmin(address eve) external {
        vm.assume(eve != address(0) && eve != users.admin);

        // Make Eve the caller in this test.
        changePrank(eve);

        // Run the test.
        vm.expectRevert(abi.encodeWithSelector(IAdminable.Adminable__CallerNotAdmin.selector, users.admin, eve));
        adminable.transferAdmin(eve);
    }

    modifier CallerAdmin() {
        _;
    }

    /// @dev it should revert.
    function testCannotTransferAdmin__CallerZeroAddress() external CallerAdmin {
        vm.expectRevert(IAdminable.Adminable__AdminZeroAddress.selector);
        adminable.transferAdmin(address(0));
    }

    modifier AdminNotZeroAddress() {
        _;
    }

    /// @dev it should emit a TransferAdmin event and re-set the admin.
    function testTransferAdmin__SameAdmin() external CallerAdmin AdminNotZeroAddress {
        vm.expectEmit({ checkTopic1: true, checkTopic2: true, checkTopic3: false, checkData: false });
        emit TransferAdmin({ oldAdmin: users.admin, newAdmin: users.admin });
        adminable.transferAdmin(users.admin);
    }

    /// @dev it should emit a TransferAdmin event and set the new admin.
    function testTransferAdmin__SameAdmin(address newAdmin) external CallerAdmin AdminNotZeroAddress {
        vm.assume(newAdmin != address(0) && newAdmin != users.admin);
        vm.expectEmit({ checkTopic1: true, checkTopic2: true, checkTopic3: false, checkData: false });
        emit TransferAdmin({ oldAdmin: users.admin, newAdmin: newAdmin });
        adminable.transferAdmin(newAdmin);
    }
}
