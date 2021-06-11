// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "./IOwnable.sol";

/// @title Ownable
/// @author Paul Razvan Berg
contract Ownable is IOwnable {
    /// @inheritdoc IOwnable
    address public override owner;

    /// @notice Throws if called by any account other than the owner.
    modifier onlyOwner() {
        require(owner == msg.sender, "NOT_OWNER");
        _;
    }

    /// @notice Initializes the contract setting the deployer as the initial owner.
    constructor() {
        address msgSender = msg.sender;
        owner = msgSender;
        emit TransferOwnership(address(0), msgSender);
    }

    /// @inheritdoc IOwnable
    function _renounceOwnership() external virtual override onlyOwner {
        emit TransferOwnership(owner, address(0));
        owner = address(0);
    }

    /// @inheritdoc IOwnable
    function _transferOwnership(address newOwner) external virtual override onlyOwner {
        require(newOwner != address(0), "TRANSFER_OWNERSHIP_ZERO_ADDRESS");
        emit TransferOwnership(owner, newOwner);
        owner = newOwner;
    }
}
