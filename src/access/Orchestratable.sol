// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import { Ownable } from "./Ownable.sol";
import { IOrchestratable } from "./IOrchestratable.sol";

/// @title Orchestratable
/// @author Paul Razvan Berg
contract Orchestratable is
    IOrchestratable, // one dependency
    Ownable // one dependency
{
    /// @inheritdoc IOrchestratable
    address public override conductor;

    /// @inheritdoc IOrchestratable
    mapping(address => mapping(bytes4 => bool)) public override orchestration;

    /// @notice Restricts usage to authorized accounts.
    modifier onlyOrchestrated() {
        if (!orchestration[msg.sender][msg.sig]) {
            revert Orchestratable__NotOrchestrated(msg.sender, msg.sig);
        }
        _;
    }

    /// @inheritdoc IOrchestratable
    function orchestrate(address account, bytes4 signature) public override onlyOwner {
        orchestration[account][signature] = true;
        emit GrantAccess(account);
    }
}
