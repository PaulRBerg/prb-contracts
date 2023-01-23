// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { ERC20PermitTest } from "../ERC20Permit.t.sol";

contract Version_Test is ERC20PermitTest {
    /// @dev it should return the EIP-2612 version.
    function test_Version() external {
        string memory actualVersion = erc20Permit.version();
        string memory expectedVersion = version;
        assertEq(actualVersion, expectedVersion, "version");
    }
}
