// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

/// @title IAdminable
/// @author Paul Razvan Berg
/// @notice Contract module that provides a basic access control mechanism, where there is an
/// account (an admin) that can be granted exclusive access to specific functions.
///
/// By default, the admin account will be the one that deploys the contract. This can later be
/// changed with {transferAdmin}.
///
/// This module is used through inheritance. It will make available the modifier `onlyAdmin`,
/// which can be applied to your functions to restrict their use to the admin.
///
/// @dev Forked from OpenZeppelin
/// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.0/contracts/access/Ownable.sol
interface IAdminable {
    /*//////////////////////////////////////////////////////////////////////////
                                    CUSTOM ERRORS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Emitted when setting the admin to the zero address.
    error Adminable_AdminZeroAddress();

    /// @notice Emitted when the caller is not the admin.
    error Adminable_CallerNotAdmin(address admin, address caller);

    /*//////////////////////////////////////////////////////////////////////////
                                       EVENTS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Emitted when the admin is transferred.
    /// @param oldAdmin The address of the old admin.
    /// @param newAdmin The address of the new admin.
    event TransferAdmin(address indexed oldAdmin, address indexed newAdmin);

    /*//////////////////////////////////////////////////////////////////////////
                                 CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice The address of the admin account or contract.
    /// @return The address of the admin.
    function admin() external view returns (address);

    /*//////////////////////////////////////////////////////////////////////////
                               NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Leaves the contract without admin, so it will not be possible to call `onlyAdmin`
    /// functions anymore.
    ///
    /// WARNING: Renouncing the admin will leave the contract without an admin, thereby removing any
    /// functionality that is only available to the admin.
    ///
    /// Requirements:
    ///
    /// - The caller must be the admin.
    function renounceAdmin() external;

    /// @notice Transfers the admin of the contract to a new account (`newAdmin`). Can only be
    /// called by the current admin.
    /// @param newAdmin The address of the new admin.
    function transferAdmin(address newAdmin) external;
}
