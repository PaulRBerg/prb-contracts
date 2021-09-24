// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "./IAdmin.sol";

/// @notice Emitted when the caller is not the admin.
error Admin__NotAdmin(address admin, address caller);

/// @notice Emitted when setting the admin to the zero address.
error Admin__AdminZeroAddress();

/// @title Admin
/// @author Paul Razvan Berg
contract Admin is IAdmin {
    /// PUBLIC STORAGE ///

    /// @inheritdoc IAdmin
    address public override admin;

    /// MODIFIERS ///

    /// @notice Throws if called by any account other than the admin.
    modifier onlyAdmin() {
        if (admin != msg.sender) {
            revert Admin__NotAdmin(admin, msg.sender);
        }
        _;
    }

    /// CONSTRUCTOR ///

    /// @notice Initializes the contract setting the deployer as the initial admin.
    constructor() {
        address msgSender = msg.sender;
        admin = msgSender;
        emit TransferAdmin(address(0), msgSender);
    }

    /// PUBLIC NON-CONSTANT FUNCTIONS ///

    /// @inheritdoc IAdmin
    function _renounceAdmin() public virtual override onlyAdmin {
        emit TransferAdmin(admin, address(0));
        admin = address(0);
    }

    /// @inheritdoc IAdmin
    function _transferAdmin(address newAdmin) public virtual override onlyAdmin {
        if (newAdmin == address(0)) {
            revert Admin__AdminZeroAddress();
        }
        emit TransferAdmin(admin, newAdmin);
        admin = newAdmin;
    }
}
