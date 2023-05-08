// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { StdUtils } from "forge-std/StdUtils.sol";

import { ERC20GodMode } from "src/token/erc20/ERC20GodMode.sol";
import { IERC20 } from "src/token/erc20/IERC20.sol";

/// @title Base_Test
/// @author Paul Razvan Berg
/// @notice Common contract members needed across test contracts.
abstract contract Base_Test is PRBTest, StdCheats, StdUtils {
    /*//////////////////////////////////////////////////////////////////////////
                                       EVENTS
    //////////////////////////////////////////////////////////////////////////*/

    event LogNamedArray(string key, IERC20[] value);

    /*//////////////////////////////////////////////////////////////////////////
                                      STRUCTS
    //////////////////////////////////////////////////////////////////////////*/

    struct Users {
        address payable alice;
        address payable admin;
        address payable bob;
        address payable eve;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                     CONSTANTS
    //////////////////////////////////////////////////////////////////////////*/

    uint256 internal constant ONE_MILLION_DAI = 1_000_000e18;
    uint256 internal constant ONE_MILLION_USDC = 1_000_000e6;

    /*//////////////////////////////////////////////////////////////////////////
                                 TESTING CONTRACTS
    //////////////////////////////////////////////////////////////////////////*/

    ERC20GodMode internal dai = new ERC20GodMode("Dai Stablecoin", "DAI", 18);
    ERC20GodMode internal tkn0 = new ERC20GodMode("Token 0", "TKN0", 0);
    ERC20GodMode internal usdc = new ERC20GodMode("USD Coin", "USDC", 6);
    Users internal users;

    /*//////////////////////////////////////////////////////////////////////////
                                   SETUP FUNCTION
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev A setup function invoked before each test case.
    function setUp() public virtual {
        // Create users for testing.
        users = Users({
            alice: createUser("Alice"),
            admin: createUser("Admin"),
            bob: createUser("Bob"),
            eve: createUser("Eve")
        });

        // Make the admin the default caller in all subsequent tests.
        vm.startPrank({ msgSender: users.admin });
    }

    /*//////////////////////////////////////////////////////////////////////////
                            INTERNAL CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function that multiplies the `amount` by `10^decimals` and returns a `uint256.`
    function bn(uint256 amount, uint256 decimals) internal pure returns (uint256 result) {
        result = amount * 10 ** decimals;
    }

    /*//////////////////////////////////////////////////////////////////////////
                          INTERNAL NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to compare two `IERC20` arrays.
    function assertEq(IERC20[] memory a, IERC20[] memory b) internal {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit Log("Error: a == b not satisfied [IERC20[]]");
            emit LogNamedArray("  Expected", b);
            emit LogNamedArray("    Actual", a);
            fail();
        }
    }

    /// @dev Helper function to compare two `IERC20` arrays.
    function assertEq(IERC20[] memory a, IERC20[] memory b, string memory err) internal {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit LogNamedString("Error", err);
            assertEq(a, b);
        }
    }

    /// @dev Generates an address by hashing the name, labels the address and funds it with 100 ETH, 1 million DAI,
    /// and 1 million non-compliant tokens.
    function createUser(string memory name) internal returns (address payable addr) {
        addr = payable(makeAddr(name));
        vm.deal({ account: addr, newBalance: 100 ether });
        dai.mint({ beneficiary: addr, amount: ONE_MILLION_DAI });
        usdc.mint({ beneficiary: addr, amount: ONE_MILLION_USDC });
    }
}
