// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import { IAdminable } from "./IAdminable.sol";

/// @title Adminable
/// @author Paul Razvan Berg
contract Adminable is IAdminable {
    /*//////////////////////////////////////////////////////////////////////////
                                USER-FACING STORAGE
    //////////////////////////////////////////////////////////////////////////*/

    /// @inheritdoc IAdminable
    address public override admin;

    /*//////////////////////////////////////////////////////////////////////////
                                     CONSTRUCTOR
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Initializes the contract setting the deployer as the initial admin.
    constructor() {
        _transferAdmin({ newAdmin: msg.sender });
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      MODIFIERS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Reverts if called by any account other than the admin.
    modifier onlyAdmin() {
        if (admin != msg.sender) {
            revert Adminable_CallerNotAdmin({ admin: admin, caller: msg.sender });
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////////////////
                               USER-FACING FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @inheritdoc IAdminable
    function renounceAdmin() public virtual override onlyAdmin {
        _transferAdmin({ newAdmin: address(0) });
    }

    /// @inheritdoc IAdminable
    function transferAdmin(address newAdmin) public virtual override onlyAdmin {
        if (newAdmin == address(0)) {
            revert Adminable_AdminZeroAddress();
        }
        _transferAdmin(newAdmin);
    }

    /*//////////////////////////////////////////////////////////////////////////
                                 INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Transfers the admin of the contract to a new account (`newAdmin`).
    /// Internal function without access restriction.
    function _transferAdmin(address newAdmin) internal virtual {
        address oldAdmin = admin;
        admin = newAdmin;
        emit TransferAdmin(oldAdmin, newAdmin);
    }
}
