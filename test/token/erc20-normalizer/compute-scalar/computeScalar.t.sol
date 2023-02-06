// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { IERC20 } from "src/token/erc20/IERC20.sol";
import { ERC20GodMode } from "src/token/erc20/ERC20GodMode.sol";
import { ERC20Normalizer } from "src/token/erc20/ERC20Normalizer.sol";
import { IERC20Normalizer } from "src/token/erc20/IERC20Normalizer.sol";

import { ERC20Normalizer_Test } from "../ERC20Normalizer.t.sol";

contract ComputeScalar_Test is ERC20Normalizer_Test {
    ERC20GodMode internal tkn19 = new ERC20GodMode("Token 19", "TKN19", 19);
    ERC20GodMode internal tkn255 = new ERC20GodMode("Token 255", "TKN18", 255);

    /// @dev it should revert.
    function test_RevertWhen_TokenDecimalsZero() external {
        vm.expectRevert(abi.encodeWithSelector(IERC20Normalizer.IERC20Normalizer_TokenDecimalsZero.selector, tkn0));
        erc20Normalizer.computeScalar({ token: tkn0 });
    }

    modifier tokenDecimalsNotZero() {
        _;
    }

    /// @dev it should revert.
    function test_RevertWhen_TokenDecimalsGreaterThan18_TokenDecimals19() external tokenDecimalsNotZero {
        uint256 decimals = 19;
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Normalizer.IERC20Normalizer_TokenDecimalsGreaterThan18.selector,
                tkn19,
                decimals
            )
        );
        erc20Normalizer.computeScalar({ token: tkn19 });
    }

    /// @dev it should revert.
    function test_RevertWhen_TokenDecimalsGreaterThan18_TokenDecimals255() external tokenDecimalsNotZero {
        uint256 decimals = 255;
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Normalizer.IERC20Normalizer_TokenDecimalsGreaterThan18.selector,
                tkn255,
                decimals
            )
        );
        erc20Normalizer.computeScalar({ token: tkn255 });
    }

    /// @dev it should compute the scalar.
    function test_ComputeScalar_TokenDecimalsEqualTo18() external {
        erc20Normalizer.computeScalar({ token: dai });
        uint256 actualScalar = erc20Normalizer.getScalar({ token: dai });
        uint256 expectedScalar = 1;
        assertEq(actualScalar, expectedScalar, "scalar");
    }

    /// @dev it should compute the scalar.
    function test_ComputeScalar_TokenDecimalsLessThan18() external {
        erc20Normalizer.computeScalar({ token: usdc });
        uint256 actualScalar = erc20Normalizer.getScalar({ token: usdc });
        uint256 expectedScalar = 10 ** (18 - usdc.decimals());
        assertEq(actualScalar, expectedScalar, "scalar");
    }
}
