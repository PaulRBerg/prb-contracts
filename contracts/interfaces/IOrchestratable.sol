// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "./IAdmin.sol";

/// @title IOrchestratable
/// @author Paul Razvan Berg
/// @notice Interface of the Orchestrable contract
interface IOrchestratable is IAdmin {
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
