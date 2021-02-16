// SPDX-License-Identifier: MIT
// solhint-disable func-name-mixedcase
pragma solidity ^0.8.0;

import "../token/erc20/Erc20Recover.sol";

/// @title GodModeErc20Recover
/// @author Paul Razvan Berg
/// @dev Strictly for test purposes. Do not use in production.
contract GodModeErc20Recover is Erc20Recover {
    function __godMode_getIsRecoverInitialized() external view returns (bool) {
        return isRecoverInitialized;
    }

    function __godMode_setIsRecoverInitialized(bool state) external {
        isRecoverInitialized = state;
    }
}
