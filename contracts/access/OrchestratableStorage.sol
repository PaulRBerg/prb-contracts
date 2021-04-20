// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

abstract contract OrchestratableStorage {
    /// @notice The address of the conductor account or contract.
    address public conductor;

    /// @notice The orchestrated contract functions.
    mapping(address => mapping(bytes4 => bool)) public orchestration;
}
