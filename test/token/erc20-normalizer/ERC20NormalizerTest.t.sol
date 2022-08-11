// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { ERC20NormalizerMock } from "../../shared/ERC20NormalizerMock.t.sol";
import { PRBContractBaseTest } from "../../PRBContractBaseTest.t.sol";

/// @title ERC20NormalizerTest
/// @author Paul Razvan Berg
/// @notice Common contract members needed across ERC20Normalizer test contracts.
abstract contract ERC20NormalizerTest is PRBContractBaseTest {
    /// CONSTANTS ///

    uint256 internal constant STANDARD_DECIMALS = 18;
    uint256 internal constant USDC_SCALAR = 10**12;

    /// TESTING VARIABLES ///

    ERC20NormalizerMock internal erc20Normalizer = new ERC20NormalizerMock();
}
