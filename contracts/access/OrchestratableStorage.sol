/* SPDX-License-Identifier: MIT */
pragma solidity ^0.7.0;

abstract contract OrchestratableStorage {
    /**
     * @notice The address of the conductor account or contract.
     */
    address public conductor;

    /**
     * @notice The orchestrated contract functions.
     */
    mapping(address => mapping(bytes4 => bool)) public orchestration;
}
