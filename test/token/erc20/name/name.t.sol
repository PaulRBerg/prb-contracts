// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { ERC20_Test } from "../ERC20.t.sol";

contract Name_Test is ERC20_Test {
    function test_Name() external {
        string memory actualName = dai.name();
        string memory expectedName = "Dai Stablecoin";
        assertEq(actualName, expectedName, "name");
    }
}
