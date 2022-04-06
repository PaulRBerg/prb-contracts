// SPDX-License-Identifier: Unlicense
// solhint-disable func-name-mixedcase
pragma solidity >=0.8.4;

import "../token/erc20/ERC20Recover.sol";

/// @title ERC20RecoverGodMode
/// @author Paul Razvan Berg
/// @dev Strictly for test purposes. Do not use in production.
contract ERC20RecoverGodMode is ERC20Recover {
    function __godMode_getIsRecoverInitialized() external view returns (bool) {
        return isRecoverInitialized;
    }

    function __godMode_setIsRecoverInitialized(bool state) external {
        isRecoverInitialized = state;
    }
}
