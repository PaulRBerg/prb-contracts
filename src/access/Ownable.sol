// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import { IOwnable } from "./IOwnable.sol";

/// @title Ownable
/// @author Paul Razvan Berg
contract Ownable is IOwnable {
    /*//////////////////////////////////////////////////////////////////////////
                                       STORAGE
    //////////////////////////////////////////////////////////////////////////*/

    /// @inheritdoc IOwnable
    address public override owner;

    /*//////////////////////////////////////////////////////////////////////////
                                      MODIFIERS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Throws if called by any account other than the owner.
    modifier onlyOwner() {
        if (owner != msg.sender) {
            revert Ownable__CallerNotOwner({ owner: owner, caller: msg.sender });
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                     CONSTRUCTOR
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Initializes the contract setting the deployer as the initial owner.
    constructor() {
        _transferOwnership({ newOwner: msg.sender });
    }

    /*//////////////////////////////////////////////////////////////////////////
                                  PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @inheritdoc IOwnable
    function renounceOwnership() public virtual override onlyOwner {
        _transferOwnership({ newOwner: address(0) });
    }

    /// @inheritdoc IOwnable
    function transferOwnership(address newOwner) public virtual override onlyOwner {
        if (newOwner == address(0)) {
            revert Ownable__OwnerZeroAddress();
        }
        emit TransferOwnership(owner, newOwner);
        owner = newOwner;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                 INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Transfers ownership of the contract to a new account (`newOwner`).
    /// Internal function without access restriction.
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = owner;
        owner = newOwner;
        emit TransferOwnership(oldOwner, newOwner);
    }
}
