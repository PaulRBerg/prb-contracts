/* SPDX-License-Identifier: MIT */
/* solhint-disable func-name-mixedcase */
pragma solidity ^0.7.3;

import "../token/erc20/Erc20Recover.sol";

/**
 * @title GodModeErc20Recover
 * @author Mainframe
 * @dev Strictly for test purposes. Do not use in production.
 */
contract GodModeErc20Recover is Erc20Recover {
    function __godMode_setIsInitialized(bool state) external {
        isInitialized = state;
    }
}
