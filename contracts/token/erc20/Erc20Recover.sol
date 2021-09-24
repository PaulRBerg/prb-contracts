// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "./IErc20.sol";
import "./IErc20Recover.sol";
import "./SafeErc20.sol";
import "../../access/Ownable.sol";

/// @notice Emitted when the contract is initialized.
error Initialized();

/// @notice Emitted when the contract is not initialized.
error NotInitialized();

/// @notice Emitted when recovering a token marked as non-recoverable.
error NonRecoverableToken(address token);

/// @notice Emitted when the amount to recover is zero.
error RecoverZero();

/// @title Erc20Recover
/// @author Paul Razvan Berg
abstract contract Erc20Recover is
    Ownable, // one dependency
    IErc20Recover // two dependencies
{
    using SafeErc20 for IErc20;

    /// PUBLIC STORAGE ///

    /// @inheritdoc IErc20Recover
    IErc20[] public override nonRecoverableTokens;

    /// @dev A flag that signals whether the the non-recoverable tokens were set or not.
    bool internal isRecoverInitialized;

    /// PUBLIC NON-CONSTANT FUNCTIONS ///

    /// @inheritdoc IErc20Recover
    function _setNonRecoverableTokens(IErc20[] memory tokens) public override onlyOwner {
        // Checks
        if (isRecoverInitialized) {
            revert Initialized();
        }

        // Iterate over the token list, sanity check each and update the mapping.
        uint256 length = tokens.length;
        for (uint256 i = 0; i < length; i += 1) {
            tokens[i].symbol();
            nonRecoverableTokens.push(tokens[i]);
        }

        // Effects: prevent this function from ever being called again.
        isRecoverInitialized = true;

        emit SetNonRecoverableTokens(owner, tokens);
    }

    /// @inheritdoc IErc20Recover
    function _recover(IErc20 token, uint256 recoverAmount) public override onlyOwner {
        // Checks
        if (!isRecoverInitialized) {
            revert NotInitialized();
        }

        if (recoverAmount == 0) {
            revert RecoverZero();
        }

        bytes32 tokenSymbolHash = keccak256(bytes(token.symbol()));
        uint256 length = nonRecoverableTokens.length;

        // We iterate over the non-recoverable token array and check that:
        //
        //   1. The addresses of the tokens are not the same.
        //   2. The symbols of the tokens are not the same.
        //
        // It is true that the second check may lead to a false positive, but there is no better way
        // to fend off against proxied tokens.
        for (uint256 i = 0; i < length; i += 1) {
            if (
                address(token) == address(nonRecoverableTokens[i]) ||
                tokenSymbolHash == keccak256(bytes(nonRecoverableTokens[i].symbol()))
            ) {
                revert NonRecoverableToken(address(token));
            }
        }

        // Interactions
        token.safeTransfer(owner, recoverAmount);

        emit Recover(owner, token, recoverAmount);
    }
}
