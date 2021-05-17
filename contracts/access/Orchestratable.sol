// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "../interfaces/IOrchestratable.sol";
import "./Admin.sol";

/// @title Orchestratable
/// @author Paul Razvan Berg
/// @notice Orchestrated static access control between multiple contracts.
///
/// This should be used as a parent contract of any contract that needs to restrict access to some methods, which
/// should be marked with the `onlyOrchestrated` modifier.
///
/// During deployment, the contract deployer (`conductor`) can register any contracts that have privileged access
/// by calling `orchestrate`.
///
/// Once deployment is completed, `conductor` should call `transferConductor(address(0))` to avoid any more
/// contracts ever gaining privileged access.
///
/// @dev Forked from Alberto Cuesta Cañada
/// https://github.com/albertocuestacanada/Orchestrated/blob/b0adb21/contracts/Orchestrated.sol
contract Orchestratable is
    IOrchestratable,
    Admin /// two dependencies
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
