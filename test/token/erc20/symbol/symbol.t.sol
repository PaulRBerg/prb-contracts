// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20UnitTest } from "../ERC20UnitTest.t.sol";

contract ERC20__Symbol is ERC20UnitTest {
    /// @dev it should return the ERC-20 symbol.
    function testSymbol() external {
        string memory actualSymbol = dai.symbol();
        string memory expectedSymbol = "DAI";
        assertEq(actualSymbol, expectedSymbol);
    }
}
