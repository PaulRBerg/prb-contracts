// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

/// @title IAdmin
/// @author Paul Razvan Berg
/// @notice Contract module which provides a basic access control mechanism, where there is an
/// account (an admin) that can be granted exclusive access to specific functions.
///
/// By default, the admin account will be the one that deploys the contract. This can later be
/// changed with {transferAdmin}.
///
/// This module is used through inheritance. It will make available the modifier `onlyAdmin`,
/// which can be applied to your functions to restrict their use to the admin.
///
/// @dev Forked from OpenZeppelin
/// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/access/Ownable.sol
interface IAdmin {
    /// EVENTS ///

    /// @notice Emitted when the admin is transferred.
    /// @param oldAdmin The address of the old admin.
    /// @param newAdmin The address of the new admin.
    event TransferAdmin(address indexed oldAdmin, address indexed newAdmin);

    /// NON-CONSTANT FUNCTIONS ///

    /// @notice Leaves the contract without admin, so it will not be possible to call `onlyAdmin`
    /// functions anymore.
    ///
    /// WARNING: Doing this will leave the contract without an admin, thereby removing any
    /// functionality that is only available to the admin.
    ///
    /// Requirements:
    ///
    /// - The caller must be the administrator.
    function _renounceAdmin() external;

    /// @notice Transfers the admin of the contract to a new account (`newAdmin`). Can only be
    /// called by the current admin.
    /// @param newAdmin The account of the new admin.
    function _transferAdmin(address newAdmin) external;

    /// CONSTANT FUNCTIONS ///

    /// @notice The address of the administrator account or contract.
    /// @return The address of the administrator.
    function admin() external view returns (address);
}
