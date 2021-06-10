// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "./Admin.sol";
import "./IOrchestratable.sol";

/// @title Orchestratable
/// @author Paul Razvan Berg
contract Orchestratable is
    IOrchestratable, // one dependency
    Admin /// one dependency
{
    /// @inheritdoc IOrchestratable
    address public override conductor;

    /// @inheritdoc IOrchestratable
    mapping(address => mapping(bytes4 => bool)) public override orchestration;

    /// @notice Restricts usage to authorized accounts.
    modifier onlyOrchestrated() {
        require(orchestration[msg.sender][msg.sig], "NOT_ORCHESTRATED");
        _;
    }

    /// @inheritdoc IOrchestratable
    function _orchestrate(address account, bytes4 signature) external override onlyAdmin {
        orchestration[account][signature] = true;
        emit GrantAccess(account);
    }
}
