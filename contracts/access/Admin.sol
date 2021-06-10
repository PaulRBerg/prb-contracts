// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "./IAdmin.sol";

/// @title Admin
/// @author Paul Razvan Berg
contract Admin is IAdmin {
    /// @inheritdoc IAdmin
    address public override admin;

    /// @notice Throws if called by any account other than the admin.
    modifier onlyAdmin() {
        require(admin == msg.sender, "NOT_ADMIN");
        _;
    }

    /// @notice Initializes the contract setting the deployer as the initial admin.
    constructor() {
        address msgSender = msg.sender;
        admin = msgSender;
        emit TransferAdmin(address(0), msgSender);
    }

    /// @inheritdoc IAdmin
    function _renounceAdmin() external virtual override onlyAdmin {
        emit TransferAdmin(admin, address(0));
        admin = address(0);
    }

    /// @inheritdoc IAdmin
    function _transferAdmin(address newAdmin) external virtual override onlyAdmin {
        require(newAdmin != address(0), "SET_ADMIN_ZERO_ADDRESS");
        emit TransferAdmin(admin, newAdmin);
        admin = newAdmin;
    }
}
