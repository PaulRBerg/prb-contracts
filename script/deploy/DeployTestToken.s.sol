// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { Script } from "forge-std/Script.sol";

import { ERC20GodMode } from "../../src/token/erc20/ERC20GodMode.sol";

import { BaseScript } from "../shared/Base.s.sol";

/// @notice Deploys a test ERC-20 token with infinite minting and burning capabilities.
contract DeployTestToken is Script, BaseScript {
    function run() public virtual broadcaster returns (ERC20GodMode token) {
        token = new ERC20GodMode("Test token", "TKN", 18);
    }
}
