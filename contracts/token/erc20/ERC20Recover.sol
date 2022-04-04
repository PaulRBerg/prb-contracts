// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "./IERC20.sol";
import "./IERC20Recover.sol";
import "./SafeERC20.sol";
import "../../access/Ownable.sol";

/// @title ERC20Recover
/// @author Paul Razvan Berg
abstract contract ERC20Recover is
    Ownable, // one dependency
    IERC20Recover // two dependencies
{
    using SafeERC20 for IERC20;

    /// PUBLIC STORAGE ///

    /// @inheritdoc IERC20Recover
    IERC20[] public override nonRecoverableTokens;

    /// @dev A flag that signals whether the the non-recoverable tokens were set or not.
    bool internal isRecoverInitialized;

    /// PUBLIC NON-CONSTANT FUNCTIONS ///

    /// @inheritdoc IERC20Recover
    function _setNonRecoverableTokens(IERC20[] memory tokens) public override onlyOwner {
        // Checks
        if (isRecoverInitialized) {
            revert ERC20Recover__Initialized();
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

    /// @inheritdoc IERC20Recover
    function _recover(IERC20 token, uint256 recoverAmount) public override onlyOwner {
        // Checks
        if (!isRecoverInitialized) {
            revert ERC20Recover__NotInitialized();
        }

        if (recoverAmount == 0) {
            revert ERC20Recover__RecoverZero();
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
                revert ERC20Recover__NonRecoverableToken(address(token));
            }
        }

        // Interactions
        token.safeTransfer(owner, recoverAmount);

        emit Recover(owner, token, recoverAmount);
    }
}
