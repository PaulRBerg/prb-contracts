// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import { ERC20Recover } from "src/token/erc20/ERC20Recover.sol";

contract ERC20RecoverMock is ERC20Recover {
    function __godMode_setIsTokenDenylistSet(bool newState) external {
        isTokenDenylistSet = newState;
    }
}
