// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

/// @title ReentrancyGuard
/// @author Paul Razvan Berg
/// @notice Contract module that helps prevent reentrant calls to a function.
///
/// Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier available, which can be applied
/// to functions to make sure there are no nested (reentrant) calls to them.
///
/// Note that because there is a single `nonReentrant` guard, functions marked as `nonReentrant` may not
/// call one another. This can be worked around by making those functions `private`, and then adding
/// `external` `nonReentrant` entry points to them.
///
/// @dev Forked from OpenZeppelin
/// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/utils/ReentrancyGuard.sol
abstract contract ReentrancyGuard {
    /// CUSTOM ERRORS ///

    /// @notice Emitted when there is a reentrancy call.
    error ReentrantCall();

    /// PRIVATE STORAGE ///

    bool private notEntered;

    /// CONSTRUCTOR ///

    /// Storing an initial non-zero value makes deployment a bit more expensive but in exchange the
    /// refund on every call to nonReentrant will be lower in amount. Since refunds are capped to a
    /// percetange of the total transaction's gas, it is best to keep them low in cases like this one,
    /// to increase the likelihood of the full refund coming into effect.
    constructor() {
        notEntered = true;
    }

    /// MODIFIERS ///

    /// @notice Prevents a contract from calling itself, directly or indirectly.
    /// @dev Calling a `nonReentrant` function from another `nonReentrant` function
    /// is not supported. It is possible to prevent this from happening by making
    /// the `nonReentrant` function external, and make it call a `private`
    /// function that does the actual work.
    modifier nonReentrant() {
        // On the first call to nonReentrant, notEntered will be true.
        if (!notEntered) {
            revert ReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail.
        notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (https://eips.ethereum.org/EIPS/eip-2200).
        notEntered = true;
    }
}
