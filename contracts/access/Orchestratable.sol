// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "./Ownable.sol";
import "./IOrchestratable.sol";

/// @notice Emitted when the caller is not an orchestrated address.
error Orchestratable__NotOrchestrated(address caller, bytes4 signature);

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
    function _orchestrate(address account, bytes4 signature) public override onlyOwner {
        orchestration[account][signature] = true;
        emit GrantAccess(account);
    }
}
