// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { IERC20 } from "@prb/contracts/token/erc20/IERC20.sol";

import { ERC20RecoverMock } from "../../shared/ERC20RecoverMock.t.sol";
import { BaseTest } from "../../BaseTest.t.sol";
import { SymbollessERC20 } from "../../shared/SymbollessERC20.t.sol";

/// @title ERC20RecoverTest
/// @notice Common contract members needed across ERC20Recover test contracts.
abstract contract ERC20RecoverTest is BaseTest {
    /*//////////////////////////////////////////////////////////////////////////
                                       EVENTS
    //////////////////////////////////////////////////////////////////////////*/

    event Recover(address indexed owner, IERC20 token, uint256 amount);
    event SetTokenDenylist(address indexed owner, IERC20[] tokenDenylist);

    /*//////////////////////////////////////////////////////////////////////////
                                     CONSTANTS
    //////////////////////////////////////////////////////////////////////////*/

    IERC20[] internal TOKEN_DENYLIST = [dai];
    uint256 internal RECOVER_AMOUNT = bn(100, 6);

    /*//////////////////////////////////////////////////////////////////////////
                                   TEST CONTRACTS
    //////////////////////////////////////////////////////////////////////////*/

    ERC20RecoverMock internal erc20Recover;
    SymbollessERC20 internal symbollessToken;

    /*//////////////////////////////////////////////////////////////////////////
                                   SETUP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev A setup function invoked before each test case.
    function setUp() public virtual override {
        BaseTest.setUp();

        // Deploy the contracts.
        erc20Recover = new ERC20RecoverMock();
        symbollessToken = new SymbollessERC20("Symbolless Token", 18);

        // Give 100 USDC to the recover contract.
        usdc.mint(address(erc20Recover), RECOVER_AMOUNT);
    }
}
