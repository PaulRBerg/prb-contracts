// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";
import { IERC20Normalizer } from "@prb/contracts/token/erc20/IERC20Normalizer.sol";
import { ERC20Normalizer } from "@prb/contracts/token/erc20/ERC20Normalizer.sol";

import { PRBContractUnitTest } from "../../PRBContractUnitTest.t.sol";

/// @title ERC20NormalizerUnitTest
/// @author Paul Razvan Berg
/// @notice Common contract members needed across ERC20Normalizer test contracts.
abstract contract ERC20NormalizerUnitTest is PRBContractUnitTest {
    /// CONSTANTS ///

    uint256 internal constant STANDARD_DECIMALS = 18;
    uint256 internal constant USDC_SCALAR = 10**12;

    /// TESTING VARIABLES ///

    ERC20Normalizer internal erc20Normalizer = new ERC20Normalizer();
}
