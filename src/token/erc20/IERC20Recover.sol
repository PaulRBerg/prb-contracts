// SPDX-License-Identifier: MIT
// solhint-disable var-name-mixedcase
pragma solidity >=0.8.4;

import { IERC20 } from "./IERC20.sol";
import { IAdminable } from "../../access/IAdminable.sol";

/// @title IERC20Recover
/// @author Paul Razvan Berg
/// @notice Contract that gives the owner the ability to recover the ERC-20 tokens that were sent
/// (accidentally, or not) to the contract.
interface IERC20Recover is IAdminable {
    /// CUSTOM ERRORS ///

    /// @notice Emitted when attempting to recover a token marked as non-recoverable.
    error ERC20Recover_RecoverNonRecoverableToken(address token);

    /// @notice Emitted when attempting to recover a zero amount of tokens.
    error ERC20Recover_RecoverAmountZero();

    /// @notice Emitted when the attempting to set the token denylist twice.
    error ERC20Recover_TokenDenylistAlreadySet();

    /// @notice Emitted when the attempting to recover a token without having set the token denylist.
    error ERC20Recover_TokenDenylistNotSet();

    /// EVENTS ///

    /// @notice Emitted when tokens are recovered.
    /// @param owner The address of the owner recoverring the tokens.
    /// @param token The address of the recovered token.
    /// @param amount The amount of recovered tokens.
    event Recover(address indexed owner, IERC20 token, uint256 amount);

    /// @notice Emitted when the token denylist is set.
    /// @param owner The address of the owner of the contract.
    /// @param tokenDenylist The array of tokens that will not be recoverable.
    event SetTokenDenylist(address indexed owner, IERC20[] tokenDenylist);

    /// CONSTANT FUNCTIONS ///

    /// @notice Getter for the token denylist.
    function getTokenDenylist() external view returns (IERC20[] memory);

    /// @notice A flag that indicates whether the token denylist is set or not. We need this because
    /// the token denylist can be set to an empty array.
    function isTokenDenylistSet() external view returns (bool);

    /// NON-CONSTANT FUNCTIONS ///

    /// @notice Initializes the contract by setting the tokens that this contract cannot recover.
    ///
    /// @dev Emits an {Initialize} event.
    ///
    /// Requirements:
    ///
    /// - The caller must be the owner.
    /// - The token denylist must not be already set.
    ///
    /// @param tokenDenylist_ The array of tokens that will not be recoverable.
    function setTokenDenylist(IERC20[] calldata tokenDenylist_) external;

    /// @notice Recovers ERC-20 tokens sent to this contract (by accident or otherwise).
    /// @dev Emits a {RecoverToken} event.
    ///
    /// Requirements:
    ///
    /// - The caller must be the owner.
    /// - The token denylist must be set.
    /// - The amount to recover must not be zero.
    /// - The token to recover must not be in the token denylist.
    ///
    /// @param token The token to make the recover for.
    /// @param amount The uint256 amount to recover, specified in the token's decimal system.
    function recover(IERC20 token, uint256 amount) external;
}
