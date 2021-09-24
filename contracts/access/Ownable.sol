// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "./IOwnable.sol";

/// @notice Emitted when the caller is not the owner.
error Ownable__NotOwner(address owner, address caller);

/// @notice Emitted when setting the owner to the zero address.
error Ownable__OwnerZeroAddress();

/// @title Ownable
/// @author Paul Razvan Berg
contract Ownable is IOwnable {
    /// PUBLIC STORAGE ///

    /// @inheritdoc IOwnable
    address public override owner;

    /// MODIFIERS ///

    /// @notice Throws if called by any account other than the owner.
    modifier onlyOwner() {
        if (owner != msg.sender) {
            revert Ownable__NotOwner(owner, msg.sender);
        }
        _;
    }

    /// CONSTRUCTOR ///

    /// @notice Initializes the contract setting the deployer as the initial owner.
    constructor() {
        address msgSender = msg.sender;
        owner = msgSender;
        emit TransferOwnership(address(0), msgSender);
    }

    /// PUBLIC NON-CONSTANT FUNCTIONS ///

    /// @inheritdoc IOwnable
    function _renounceOwnership() public virtual override onlyOwner {
        emit TransferOwnership(owner, address(0));
        owner = address(0);
    }

    /// @inheritdoc IOwnable
    function _transferOwnership(address newOwner) public virtual override onlyOwner {
        if (newOwner == address(0)) {
            revert Ownable__OwnerZeroAddress();
        }
        emit TransferOwnership(owner, newOwner);
        owner = newOwner;
    }
}
