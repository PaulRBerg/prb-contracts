// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20PermitUnitTest } from "../ERC20PermitUnitTest.t.sol";

contract ERC20Permit__PermitTypehash is ERC20PermitUnitTest {
    /// @dev it should return the EIP-2612 permit typehash.
    function testPermitTypehash() external {
        bytes32 actualPermitTypehash = erc20Permit.PERMIT_TYPEHASH();
        bytes32 expectedPermitTypehash = PERMIT_TYPEHASH;
        assertEq(actualPermitTypehash, expectedPermitTypehash);
    }
}
