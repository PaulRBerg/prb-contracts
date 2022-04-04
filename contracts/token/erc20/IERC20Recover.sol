// SPDX-License-Identifier: Unlicense
// solhint-disable var-name-mixedcase
pragma solidity >=0.8.4;

import "./IERC20.sol";
import "../../access/IOwnable.sol";

/// @title IERC20Recover
/// @author Paul Razvan Berg
/// @notice Contract that gives the owner the ability to recover the ERC-20 tokens that were sent
/// (accidentally, or not) to the contract.
interface IERC20Recover is IOwnable {
    /// CUSTOM ERRORS ///

    /// @notice Emitted when the contract is initialized.
    error ERC20Recover__Initialized();

    /// @notice Emitted when the contract is not initialized.
    error ERC20Recover__NotInitialized();

    /// @notice Emitted when recovering a token marked as non-recoverable.
    error ERC20Recover__NonRecoverableToken(address token);

    /// @notice Emitted when the amount to recover is zero.
    error ERC20Recover__RecoverZero();

    /// EVENTS ///

    /// @notice Emitted when tokens are recovered.
    /// @param owner The address of the owner recoverring the tokens.
    /// @param token The address of the recovered token.
    /// @param recoverAmount The amount of recovered tokens.
    event Recover(address indexed owner, IERC20 token, uint256 recoverAmount);

    /// @notice Emitted when tokens are set as non-recoverable.
    /// @param owner The address of the owner calling the function.
    /// @param nonRecoverableTokens An array of token addresses.
    event SetNonRecoverableTokens(address indexed owner, IERC20[] nonRecoverableTokens);

    /// NON-CONSTANT FUNCTIONS ///

    /// @notice Recover ERC-20 tokens sent to this contract (by accident or otherwise).
    /// @dev Emits a {RecoverToken} event.
    ///
    /// Requirements:
    ///
    /// - The caller must be the owner.
    /// - The contract must be initialized.
    /// - The amount to recover cannot be zero.
    /// - The token to recover cannot be among the non-recoverable tokens.
    ///
    /// @param token The token to make the recover for.
    /// @param recoverAmount The uint256 amount to recover, specified in the token's decimal system.
    function _recover(IERC20 token, uint256 recoverAmount) external;

    /// @notice Sets the tokens that this contract cannot recover.
    ///
    /// @dev Emits a {SetNonRecoverableTokens} event.
    ///
    /// Requirements:
    ///
    /// - The caller must be the owner.
    /// - The contract cannot be already initialized.
    ///
    /// @param tokens The array of tokens to set as non-recoverable.
    function _setNonRecoverableTokens(IERC20[] calldata tokens) external;

    /// CONSTANT FUNCTIONS ///

    /// @notice The tokens that can be recovered cannot be in this mapping.
    function nonRecoverableTokens(uint256 index) external view returns (IERC20);
}
