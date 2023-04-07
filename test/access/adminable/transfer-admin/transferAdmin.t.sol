// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { IAdminable } from "src/access/IAdminable.sol";

import { AdminableTest } from "../Adminable.t.sol";

contract TransferAdmin_Test is AdminableTest {
    function testFuzz_RevertWhen_CallerNotAdmin(address eve) external {
        vm.assume(eve != address(0) && eve != users.admin);

        // Make Eve the caller in this test.
        changePrank(eve);

        // Run the test.
        vm.expectRevert(abi.encodeWithSelector(IAdminable.Adminable_CallerNotAdmin.selector, users.admin, eve));
        adminable.transferAdmin(eve);
    }

    modifier whenCallerAdmin() {
        _;
    }

    function test_RevertWhen_NewAdminZeroAddress() external whenCallerAdmin {
        vm.expectRevert(IAdminable.Adminable_AdminZeroAddress.selector);
        adminable.transferAdmin(address(0));
    }

    modifier whenAdminNotZeroAddress() {
        _;
    }

    function test_TransferAdmin_SameAdmin() external whenCallerAdmin whenAdminNotZeroAddress {
        vm.expectEmit();
        emit TransferAdmin({ oldAdmin: users.admin, newAdmin: users.admin });
        adminable.transferAdmin(users.admin);
        address actualAdmin = adminable.admin();
        address expectedAdmin = users.admin;
        assertEq(actualAdmin, expectedAdmin, "admin");
    }

    function testFuzz_TransferAdmin_NewAdmin(address newAdmin) external whenCallerAdmin whenAdminNotZeroAddress {
        vm.assume(newAdmin != address(0) && newAdmin != users.admin);
        vm.expectEmit();
        emit TransferAdmin({ oldAdmin: users.admin, newAdmin: newAdmin });
        adminable.transferAdmin(newAdmin);
        address actualAdmin = adminable.admin();
        address expectedAdmin = newAdmin;
        assertEq(actualAdmin, expectedAdmin, "admin");
    }
}
