// SPDX-License-Identifier: Unlicense
// solhint-disable var-name-mixedcase
pragma solidity >=0.8.4;

import "./ERC20.sol";
import "./IERC20Permit.sol";

/// @title ERC20Permit
/// @author Paul Razvan Berg
contract ERC20Permit is
    IERC20Permit, // one dependency
    ERC20 // one dependency
{
    /// PUBLIC STORAGE ///

    /// @inheritdoc IERC20Permit
    bytes32 public immutable override DOMAIN_SEPARATOR;

    /// @inheritdoc IERC20Permit
    bytes32 public constant override PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    /// @inheritdoc IERC20Permit
    mapping(address => uint256) public override nonces;

    /// @inheritdoc IERC20Permit
    string public constant override version = "1";

    /// CONSTRUCTOR ///

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20(_name, _symbol, _decimals) {
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

    /// PUBLIC NON-CONSTANT FUNCTIONS ///

    /// @inheritdoc IERC20Permit
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public override {
        if (owner == address(0)) {
            revert ERC20Permit__OwnerZeroAddress();
        }
        if (spender == address(0)) {
            revert ERC20Permit__SpenderZeroAddress();
        }
        if (deadline < block.timestamp) {
            revert ERC20Permit__PermitExpired(deadline);
        }

        // It's safe to use unchecked here because the nonce cannot realistically overflow, ever.
        bytes32 hashStruct;
        unchecked {
            hashStruct = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline));
        }
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hashStruct));
        address recoveredOwner = ecrecover(digest, v, r, s);

        if (recoveredOwner == address(0)) {
            revert ERC20Permit__RecoveredOwnerZeroAddress();
        }
        if (recoveredOwner != owner) {
            revert ERC20Permit__InvalidSignature(v, r, s);
        }

        approveInternal(owner, spender, value);
    }
}
