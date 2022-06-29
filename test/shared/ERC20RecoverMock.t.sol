// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { ERC20Recover } from "@prb/contracts/token/erc20/ERC20Recover.sol";

contract ERC20RecoverMock is ERC20Recover {
    function __godMode_setIsTokenDenylistSet(bool newState) external {
        isTokenDenylistSet = newState;
    }
}
