/* SPDX-License-Identifier: MIT */
pragma solidity ^0.7.3;

import "./OrchestratableStorage.sol";

/**
 * @title OrchestratableInterface
 * @author Paul Razvan Berg
 */
abstract contract OrchestratableInterface is OrchestratableStorage {
    /**
     * NON-CONSTANTS FUNCTIONS
     */
    function orchestrate(address account, bytes4 signature) external virtual;

    /**
     * EVENTS
     */
    event GrantAccess(address access);

    event TransferConductor(address indexed oldConductor, address indexed newConductor);
}
