// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "../../access/Admin.sol";
import "../../interfaces/IErc20.sol";
import "../../interfaces/IErc20Recover.sol";
import "./SafeErc20.sol";

/// @title Erc20Recover
/// @author Paul Razvan Berg
/// @notice Gives the administrator the ability to recover the Erc20 tokens that
/// had been sent (accidentally, or not) to the contract.
abstract contract Erc20Recover is
    IErc20Recover,
    Admin /// two dependencies
{
    using SafeErc20 for IErc20;

    /// @inheritdoc IErc20Recover
    IErc20[] public override nonRecoverableTokens;

    /// @dev A flag that signals whether the the non-recoverable tokens were set or not.
    bool internal isRecoverInitialized;

    /// @inheritdoc IErc20Recover
    function _setNonRecoverableTokens(IErc20[] calldata tokens) external override onlyAdmin {
        // Checks
        require(isRecoverInitialized == false, "ERR_INITALIZED");

        // Iterate over the token list, sanity check each and update the mapping.
        uint256 length = tokens.length;
        for (uint256 i = 0; i < length; i += 1) {
            tokens[i].symbol();
            nonRecoverableTokens.push(tokens[i]);
        }

        // Effects: prevent this function from ever being called again.
        isRecoverInitialized = true;

        emit SetNonRecoverableTokens(admin, tokens);
    }

    /// @inheritdoc IErc20Recover
    function _recover(IErc20 token, uint256 recoverAmount) external override onlyAdmin {
        // Checks
        require(isRecoverInitialized == true, "ERR_NOT_INITALIZED");
        require(recoverAmount > 0, "ERR_RECOVER_ZERO");

        bytes32 tokenSymbolHash = keccak256(bytes(token.symbol()));
        uint256 length = nonRecoverableTokens.length;

        // We iterate over the non-recoverable token array and check that:
        //
        //   1. The addresses of the tokens are not the same
        //   2. The symbols of the tokens are not the same
        //
        // It is true that the second check may lead to a false positive, but
        // there is no better way to fend off against proxied tokens.
        for (uint256 i = 0; i < length; i += 1) {
            require(
                address(token) != address(nonRecoverableTokens[i]) &&
                    tokenSymbolHash != keccak256(bytes(nonRecoverableTokens[i].symbol())),
                "ERR_RECOVER_NON_RECOVERABLE_TOKEN"
            );
        }

        // Interactions
        token.safeTransfer(admin, recoverAmount);

        emit Recover(admin, token, recoverAmount);
    }
}
