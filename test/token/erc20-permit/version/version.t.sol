// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20PermitTest } from "../ERC20Permit.t.sol";

contract ERC20Permit__Version is ERC20PermitTest {
    /// @dev it should return the EIP-2612 version.
    function testVersion() external {
        string memory actualVersion = erc20Permit.version();
        string memory expectedVersion = version;
        assertEq(actualVersion, expectedVersion);
    }
}
