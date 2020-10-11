/* SPDX-License-Identifier: MIT */
pragma solidity ^0.7.3;

abstract contract AdminStorage {
    /**
     * @notice The address of the administrator account or contract.
     */
    address public admin;
}
