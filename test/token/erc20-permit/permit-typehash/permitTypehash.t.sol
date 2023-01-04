// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20PermitTest } from "../ERC20Permit.t.sol";

contract ERC20Permit__PermitTypehash is ERC20PermitTest {
    /// @dev it should return the EIP-2612 permit typehash.
    function testPermitTypehash() external {
        bytes32 actualPermitTypehash = erc20Permit.PERMIT_TYPEHASH();
        bytes32 expectedPermitTypehash = PERMIT_TYPEHASH;
        assertEq(actualPermitTypehash, expectedPermitTypehash);
    }
}
