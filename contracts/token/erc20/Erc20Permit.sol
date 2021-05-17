// SPDX-License-Identifier: WTFPL
// solhint-disable var-name-mixedcase
pragma solidity >=0.8.0;

import "./Erc20.sol";
import "./IErc20Permit.sol";

/// @title Erc20Permit
/// @author Paul Razvan Berg
/// @notice Extension of Erc20 that allows token holders to use their tokens without sending any
/// transactions by setting the allowance with a signature using the `permit` method, and then spend
/// them via `transferFrom`.
/// @dev See https://eips.ethereum.org/EIPS/eip-2612.
contract Erc20Permit is
    IErc20Permit, // one dependency
    Erc20 // one dependency
{
    /// @inheritdoc IErc20Permit
    bytes32 public immutable override DOMAIN_SEPARATOR;

    /// @inheritdoc IErc20Permit
    bytes32 public constant override PERMIT_TYPEHASH =
        0xfc77c2b9d30fe91687fd39abb7d16fcdfe1472d065740051ab8b13e4bf4a617f;

    /// @inheritdoc IErc20Permit
    mapping(address => uint256) public override nonces;

    /// @inheritdoc IErc20Permit
    string public constant override version = "1";

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) Erc20(_name, _symbol, _decimals) {
        uint256 chainId;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            chainId := chainid()
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                chainId,
                address(this)
            )
        );
    }

    /// @inheritdoc IErc20Permit
    function permit(
        address owner,
        address spender,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override {
        require(owner != address(0), "ERC20_PERMIT_OWNER_ZERO_ADDRESS");
        require(spender != address(0), "ERC20_PERMIT_SPENDER_ZERO_ADDRESS");
        require(deadline >= block.timestamp, "ERC20_PERMIT_EXPIRED");

        // It's safe to use the "+" operator here because the nonce cannot realistically overflow, ever.
        bytes32 hashStruct = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hashStruct));
        address recoveredOwner = ecrecover(digest, v, r, s);

        require(recoveredOwner != address(0), "ERC20_PERMIT_RECOVERED_OWNER_ZERO_ADDRESS");
        require(recoveredOwner == owner, "ERC20_PERMIT_INVALID_SIGNATURE");

        approveInternal(owner, spender, amount);
    }
}
