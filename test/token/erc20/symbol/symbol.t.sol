// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20Test } from "../ERC20.t.sol";

contract ERC20__Symbol is ERC20Test {
    /// @dev it should return the ERC-20 symbol.
    function testSymbol() external {
        string memory actualSymbol = dai.symbol();
        string memory expectedSymbol = "DAI";
        assertEq(actualSymbol, expectedSymbol);
    }
}
