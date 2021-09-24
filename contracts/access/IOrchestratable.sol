// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "./IOwnable.sol";

/// @title IOrchestratable
/// @author Paul Razvan Berg
/// @notice Orchestrated static access control between multiple contracts.
///
/// This should be used as a parent contract of any contract that needs to restrict access to some methods, which
/// should be marked with the `onlyOrchestrated` modifier.
///
/// During deployment, the contract deployer (`conductor`) can register any contracts that have privileged access
/// by calling `orchestrate`.
///
/// Once deployment is completed, `conductor` should call `transferConductor(address(0))` to avoid any more
/// contracts ever gaining privileged access.
///
/// @dev Forked from Alberto Cuesta Cañada
/// https://github.com/albertocuestacanada/Orchestrated/blob/b0adb21/contracts/Orchestrated.sol
interface IOrchestratable is IOwnable {
    /// EVENTS ///

    /// @notice Emitted when access is granted to a new address.
    /// @param access The new granted address.
    event GrantAccess(address access);

    /// @notice Emitted when the conductor is transferred.
    /// @param oldConductor The address of the old conductor.
    /// @param newConductor The address of the new conductor.
    event TransferConductor(address indexed oldConductor, address indexed newConductor);

    /// NON-CONSTANT FUNCTIONS ///

    /// @notice Adds new orchestrated address.
    /// @param account Address of EOA or contract to give access to this contract.
    /// @param signature bytes4 signature of the function to be given orchestrated access to.
    function _orchestrate(address account, bytes4 signature) external;

    /// CONSTANT FUNCTIONS ///

    /// @notice The address of the conductor account or contract.
    /// @return The address of the conductor.
    function conductor() external view returns (address);

    /// @notice Checks the access of an account to a function.
    /// @param account Address of EOA or contract to check.
    /// @param signature The signature of the function to check.
    /// @return True if the account has access.
    function orchestration(address account, bytes4 signature) external view returns (bool);
}
