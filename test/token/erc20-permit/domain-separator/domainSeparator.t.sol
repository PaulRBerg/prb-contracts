// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { ERC20Permit_Test } from "../ERC20Permit.t.sol";

contract DomainSeparator_Test is ERC20Permit_Test {
    /// @dev it should return the EIP-2612 domain separator.
    function test_DomainSeparator() external {
        bytes32 actualDomainSeparator = erc20Permit.DOMAIN_SEPARATOR();
        bytes32 expectedDomainSeparator = DOMAIN_SEPARATOR;
        assertEq(actualDomainSeparator, expectedDomainSeparator, "domainSeparator");
    }
}
