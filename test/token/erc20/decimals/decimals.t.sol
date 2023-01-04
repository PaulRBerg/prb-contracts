// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20Test } from "../ERC20.t.sol";

contract ERC20__Decimals is ERC20Test {
    /// @dev it should return the ERC-20 decimals
    function testDecimals() external {
        uint8 actualDecimals = dai.decimals();
        uint8 expectedDecimals = 18;
        assertEq(actualDecimals, expectedDecimals);
    }
}
