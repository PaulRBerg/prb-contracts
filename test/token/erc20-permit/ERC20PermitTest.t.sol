// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20Permit } from "@prb/contracts/token/erc20/ERC20Permit.sol";

import { PRBContractBaseTest } from "../../PRBContractBaseTest.t.sol";

/// @title ERC20PermitTest
/// @author Paul Razvan Berg
/// @notice Common contract members needed across ERC20Permit test contracts.
abstract contract ERC20PermitTest is PRBContractBaseTest {
    /// EVENTS ///

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    /// CONSTANTS ///

    // December 31, 2099 at 16:00 UTC
    uint256 internal constant DECEMBER_2099 = 4_102_416_000;
    bytes32 internal immutable DOMAIN_SEPARATOR;
    uint8 internal constant DUMMY_V = 27;
    bytes32 internal constant DUMMY_R = bytes32(uint256(0x01));
    bytes32 internal constant DUMMY_S = bytes32(uint256(0x02));
    bytes32 internal constant PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    // https://en.bitcoin.it/wiki/Secp256k1
    uint256 internal constant SECP256K1_ORDER = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
    string internal constant version = "1";

    /// TESTING VARIABLES ///

    ERC20Permit internal erc20Permit = new ERC20Permit("EIP-2612 Permit Token", "PERMIT", 18);

    /// CONSTRUCTOR ///

    constructor() {
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(erc20Permit.name())),
                keccak256(bytes(version)),
                block.chainid,
                address(erc20Permit)
            )
        );
    }

    /// INTERNAL NON-CONSTANT FUNCTIONS ///

    /// @dev Helper function to generate an EIP-712 digest, and then sign it.
    function getSignature(
        uint256 privateKey,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline
    )
        internal
        returns (
            uint8 v,
            bytes32 r,
            bytes32 s
        )
    {
        uint256 nonce = 0;
        bytes32 hashStruct = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonce, deadline));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hashStruct));
        (v, r, s) = vm.sign(privateKey, digest);
    }
}
