// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { IAdminable } from "src/access/IAdminable.sol";

import { AdminableTest } from "../Adminable.t.sol";

contract RenounceAdmin_Test is AdminableTest {
    function testFuzz_RevertWhen_CallerNotAdmin(address eve) external {
        vm.assume(eve != address(0) && eve != users.admin);

        // Make Eve the caller in this test.
        changePrank(eve);

        // Run the test.
        vm.expectRevert(abi.encodeWithSelector(IAdminable.Adminable_CallerNotAdmin.selector, users.admin, eve));
        adminable.renounceAdmin();
    }

    modifier whenCallerAdmin() {
        _;
    }

    function test_RenounceAdmin() external whenCallerAdmin {
        vm.expectEmit({ emitter: address(adminable) });
        emit TransferAdmin({ oldAdmin: users.admin, newAdmin: address(0) });
        adminable.renounceAdmin();
        address actualAdmin = adminable.admin();
        address expectedAdmin = address(0);
        assertEq(actualAdmin, expectedAdmin, "admin");
    }
}
