// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20Test } from "../ERC20Test.t.sol";

contract ERC20__Name is ERC20Test {
    /// @dev it should return the ERC-20 name.
    function testName() external {
        string memory actualName = dai.name();
        string memory expectedName = "Dai Stablecoin";
        assertEq(actualName, expectedName);
    }
}
