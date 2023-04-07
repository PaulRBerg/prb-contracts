// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { ERC20Permit_Test } from "../ERC20Permit.t.sol";

contract Version_Test is ERC20Permit_Test {
    function test_Version() external {
        string memory actualVersion = erc20Permit.version();
        string memory expectedVersion = version;
        assertEq(actualVersion, expectedVersion, "version");
    }
}
