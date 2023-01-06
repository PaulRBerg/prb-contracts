// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import { Adminable } from "./Adminable.sol";
import { IOrchestratable } from "./IOrchestratable.sol";

/// @title Orchestratable
/// @author Paul Razvan Berg
contract Orchestratable is
    IOrchestratable, // one dependency
    Adminable // one dependency
{
    /// @inheritdoc IOrchestratable
    address public override conductor;

    /// @inheritdoc IOrchestratable
    mapping(address => mapping(bytes4 => bool)) public override orchestration;

    /// @notice Restricts usage to authorized accounts.
    modifier onlyOrchestrated() {
        if (!orchestration[msg.sender][msg.sig]) {
            revert Orchestratable_NotOrchestrated(msg.sender, msg.sig);
        }
        _;
    }

    /// @inheritdoc IOrchestratable
    function orchestrate(address account, bytes4 signature) public override onlyAdmin {
        orchestration[account][signature] = true;
        emit GrantAccess(account);
    }
}
