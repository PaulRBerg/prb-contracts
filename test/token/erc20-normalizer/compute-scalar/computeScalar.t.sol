// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "src/token/erc20/IERC20.sol";
import { ERC20GodMode } from "src/token/erc20/ERC20GodMode.sol";
import { ERC20Normalizer } from "src/token/erc20/ERC20Normalizer.sol";
import { IERC20Normalizer } from "src/token/erc20/IERC20Normalizer.sol";

import { ERC20NormalizerTest } from "../ERC20Normalizer.t.sol";

contract ComputeScalar_Test is ERC20NormalizerTest {
    ERC20GodMode internal tkn19 = new ERC20GodMode("Token 19", "TKN19", 19);
    ERC20GodMode internal tkn255 = new ERC20GodMode("Token 255", "TKN18", 255);

    /// @dev it should revert.
    function test_RevertWhen_TokenDecimalsZero() external {
        vm.expectRevert(abi.encodeWithSelector(IERC20Normalizer.IERC20Normalizer_TokenDecimalsZero.selector, tkn0));
        erc20Normalizer.computeScalar(tkn0);
    }

    modifier TokenDecimalsNotZero() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_TokenDecimalsGreaterThan18_TokenDecimals19() external TokenDecimalsNotZero {
        uint256 decimals = 19;
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Normalizer.IERC20Normalizer_TokenDecimalsGreaterThan18.selector,
                tkn19,
                decimals
            )
        );
        erc20Normalizer.computeScalar(tkn19);
    }

    /// @dev it should revert.
    function test_RevertWhen_TokenDecimalsGreaterThan18_TokenDecimals255() external TokenDecimalsNotZero {
        uint256 decimals = 255;
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Normalizer.IERC20Normalizer_TokenDecimalsGreaterThan18.selector,
                tkn255,
                decimals
            )
        );
        erc20Normalizer.computeScalar(tkn255);
    }

    /// @dev it should compute the scalar.
    function test_ComputeScalar_TokenDecimalsEqualTo18() external {
        erc20Normalizer.computeScalar(dai);
        uint256 actualScalar = erc20Normalizer.getScalar(dai);
        uint256 expectedScalar = 1;
        assertEq(actualScalar, expectedScalar);
    }

    /// @dev it should compute the scalar.
    function test_ComputeScalar_TokenDecimalsLessThan18() external {
        erc20Normalizer.computeScalar(usdc);
        uint256 actualScalar = erc20Normalizer.getScalar(usdc);
        uint256 expectedScalar = 10**(18 - usdc.decimals());
        assertEq(actualScalar, expectedScalar);
    }
}
