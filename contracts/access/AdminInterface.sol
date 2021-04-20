// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "./AdminStorage.sol";

/// @title AdminInterface
/// @author Paul Razvan Berg
abstract contract AdminInterface is AdminStorage {
    /// NON-CONSTANT FUNCTIONS ///
    function _renounceAdmin() external virtual;

    function _transferAdmin(address newAdmin) external virtual;

    /// EVENTS ///
    event TransferAdmin(address indexed oldAdmin, address indexed newAdmin);
}
