// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { ERC20_Test } from "../ERC20.t.sol";

contract Symbol_Test is ERC20_Test {
    /// @dev it should return the ERC-20 symbol.
    function test_Symbol() external {
        string memory actualSymbol = dai.symbol();
        string memory expectedSymbol = "DAI";
        assertEq(actualSymbol, expectedSymbol, "symbol");
    }
}
