// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { ERC20_Test } from "../ERC20.t.sol";

contract Decimals_Test is ERC20_Test {
    /// @dev it should return the ERC-20 decimals.
    function test_Decimals() external {
        uint8 actualDecimals = dai.decimals();
        uint8 expectedDecimals = 18;
        assertEq(actualDecimals, expectedDecimals, "decimals");
    }
}
