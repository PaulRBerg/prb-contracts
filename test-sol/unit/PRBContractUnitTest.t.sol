// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { ERC20GodMode } from "@prb/contracts/token/erc20/ERC20GodMode.sol";
import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { Test } from "forge-std/Test.sol";

/// @title PRBContractUnitTest
/// @author Paul Razvan Berg
/// @notice Common contract members needed across Sablier V2 test contracts.
/// @dev Strictly for test purposes.
abstract contract PRBContractUnitTest is Test {
    /// SETUP FUNCTION ///

    /// @dev A setup function invoked before each test case.
    function setUp() public virtual {
        // Sets all subsequent calls' `msg.sender` to be the same address as defined in `foundry.toml`.
        vm.startPrank(0x1D970A764a53b5234577f1FA19577D36f0e7C52d);
    }

    /// STORAGE ///

    bytes32 internal nextUser = keccak256(abi.encodePacked("user address"));
    ERC20GodMode internal dai = new ERC20GodMode("Dai Stablecoin", "DAI", 18);
    ERC20GodMode internal tkn0 = new ERC20GodMode("Token 0", "TKN0", 0);
    ERC20GodMode internal usdc = new ERC20GodMode("USD Coin", "USDC", 6);

    /// CONSTANT FUNCTIONS ///

    /// @dev Helper function that multiplies the `amount` by `10^18` and returns a `uint256.`
    function bn(uint256 amount) internal pure returns (uint256 result) {
        result = bn(amount, 18);
    }

    /// @dev Helper function that multiplies the `amount` by `10^decimals` and returns a `uint256.`
    function bn(uint256 amount, uint256 decimals) internal pure returns (uint256 result) {
        result = amount * 10**decimals;
    }
}
