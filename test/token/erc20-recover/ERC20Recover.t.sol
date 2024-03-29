// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { IERC20 } from "src/token/erc20/IERC20.sol";

import { ERC20RecoverMock } from "../../shared/ERC20RecoverMock.t.sol";
import { Base_Test } from "../../Base.t.sol";
import { SymbollessERC20 } from "../../shared/SymbollessERC20.t.sol";

/// @notice Common logic needed by all {ERC20Recover} unit tests.
abstract contract ERC20Recover_Test is Base_Test {
    /*//////////////////////////////////////////////////////////////////////////
                                       EVENTS
    //////////////////////////////////////////////////////////////////////////*/

    event Recover(address indexed owner, IERC20 indexed token, uint256 amount);
    event SetTokenDenylist(address indexed owner, IERC20[] tokenDenylist);

    /*//////////////////////////////////////////////////////////////////////////
                                     CONSTANTS
    //////////////////////////////////////////////////////////////////////////*/

    IERC20[] internal TOKEN_DENYLIST = [dai];
    uint256 internal constant DEFAULT_RECOVER_AMOUNT = 100e6;

    /*//////////////////////////////////////////////////////////////////////////
                                   TEST CONTRACTS
    //////////////////////////////////////////////////////////////////////////*/

    ERC20RecoverMock internal erc20Recover;
    SymbollessERC20 internal symbollessToken;

    /*//////////////////////////////////////////////////////////////////////////
                                   SETUP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    function setUp() public virtual override {
        Base_Test.setUp();

        // Deploy the contracts.
        erc20Recover = new ERC20RecoverMock();
        symbollessToken = new SymbollessERC20("Symbolless Token", 18);

        // Give 100 USDC to the recover contract.
        usdc.mint(address(erc20Recover), DEFAULT_RECOVER_AMOUNT);
    }
}
