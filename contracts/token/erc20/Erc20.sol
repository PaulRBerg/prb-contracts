// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "./IErc20.sol";

/// @notice Emitted when the owner is the zero address.
error Erc20__ApproveOwnerZeroAddress();

/// @notice Emitted when the spender is the zero address.
error Erc20__ApproveSpenderZeroAddress();

/// @notice Emitted when burning more tokens than are in the account.
error Erc20__BurnUnderflow(uint256 accountBalance, uint256 burnAmount);

/// @notice Emitted when the holder is the zero address.
error Erc20__BurnZeroAddress();

/// @notice Emitted when the owner did not give the spender sufficient allowance.
error Erc20__InsufficientAllowance(uint256 allowance, uint256 amount);

/// @notice Emitted when tranferring more tokens than there are in the account.
error Erc20__InsufficientBalance(uint256 senderBalance, uint256 amount);

/// @notice Emitted when the beneficiary is the zero address.
error Erc20__MintZeroAddress();

/// @notice Emitted when the sender is the zero address.
error Erc20__TransferSenderZeroAddress();

/// @notice Emitted when the recipient is the zero address.
error Erc20__TransferRecipientZeroAddress();

/// @title Erc20
/// @author Paul Razvan Berg
contract Erc20 is IErc20 {
    /// PUBLIC STORAGE ///

    /// @inheritdoc IErc20
    string public override name;

    /// @inheritdoc IErc20
    string public override symbol;

    /// @inheritdoc IErc20
    uint8 public immutable override decimals;

    /// @inheritdoc IErc20
    uint256 public override totalSupply;

    /// INTERNAL STORAGE ///

    /// @dev Internal mapping of balances.
    mapping(address => uint256) internal balances;

    /// @dev Internal mapping of allowances.
    mapping(address => mapping(address => uint256)) internal allowances;

    /// CONSTRUCTOR ///

    /// @notice All three of these arguments are immutable: they can only be set once during construction.
    /// @param name_ Erc20 name of this token.
    /// @param symbol_ Erc20 symbol of this token.
    /// @param decimals_ Erc20 decimal precision of this token.
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
    }

    /// PUBLIC CONSTANT FUNCTIONS ///

    /// @inheritdoc IErc20
    function allowance(address owner, address spender) public view override returns (uint256) {
        return allowances[owner][spender];
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return balances[account];
    }

    /// PUBLIC NON-CONSTANT FUNCTIONS ///

    /// @inheritdoc IErc20
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        approveInternal(msg.sender, spender, amount);
        return true;
    }

    /// @inheritdoc IErc20
    function decreaseAllowance(address spender, uint256 subtractedAmount) public virtual override returns (bool) {
        uint256 newAllowance = allowances[msg.sender][spender] - subtractedAmount;
        approveInternal(msg.sender, spender, newAllowance);
        return true;
    }

    /// @inheritdoc IErc20
    function increaseAllowance(address spender, uint256 addedAmount) public virtual override returns (bool) {
        uint256 newAllowance = allowances[msg.sender][spender] + addedAmount;
        approveInternal(msg.sender, spender, newAllowance);
        return true;
    }

    /// @inheritdoc IErc20
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        transferInternal(msg.sender, recipient, amount);
        return true;
    }

    /// @inheritdoc IErc20
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        transferInternal(sender, recipient, amount);

        uint256 currentAllowance = allowances[sender][msg.sender];
        if (currentAllowance < amount) {
            revert Erc20__InsufficientAllowance(currentAllowance, amount);
        }
        unchecked {
            approveInternal(sender, msg.sender, currentAllowance - amount);
        }

        return true;
    }

    /// INTERNAL NON-CONSTANT FUNCTIONS ///

    /// @notice Sets `amount` as the allowance of `spender` over the `owner`s tokens.
    ///
    /// @dev Emits an {Approval} event.
    ///
    /// Requirements:
    ///
    /// - `owner` cannot be the zero address.
    /// - `spender` cannot be the zero address.
    function approveInternal(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        if (owner == address(0)) {
            revert Erc20__ApproveOwnerZeroAddress();
        }
        if (spender == address(0)) {
            revert Erc20__ApproveSpenderZeroAddress();
        }

        allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /// @notice Destroys `burnAmount` tokens from `holder`, reducing the token supply.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// Requirements:
    ///
    /// - `holder` must have at least `amount` tokens.
    function burnInternal(address holder, uint256 burnAmount) internal {
        if (holder == address(0)) {
            revert Erc20__BurnZeroAddress();
        }

        // Burn the tokens.
        balances[holder] -= burnAmount;

        // Reduce the total supply.
        totalSupply -= burnAmount;

        emit Transfer(holder, address(0), burnAmount);
    }

    /// @notice Prints new tokens into existence and assigns them to `beneficiary`, increasing the
    /// total supply.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// Requirements:
    ///
    /// - The beneficiary's balance and the total supply cannot overflow.
    function mintInternal(address beneficiary, uint256 mintAmount) internal {
        if (beneficiary == address(0)) {
            revert Erc20__MintZeroAddress();
        }

        /// Mint the new tokens.
        balances[beneficiary] += mintAmount;

        /// Increase the total supply.
        totalSupply += mintAmount;

        emit Transfer(address(0), beneficiary, mintAmount);
    }

    /// @notice Moves `amount` tokens from `sender` to `recipient`.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// Requirements:
    ///
    /// - `sender` cannot be the zero address.
    /// - `recipient` cannot be the zero address.
    /// - `sender` must have a balance of at least `amount`.
    function transferInternal(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        if (sender == address(0)) {
            revert Erc20__TransferSenderZeroAddress();
        }
        if (recipient == address(0)) {
            revert Erc20__TransferRecipientZeroAddress();
        }

        uint256 senderBalance = balances[sender];
        if (senderBalance < amount) {
            revert Erc20__InsufficientBalance(senderBalance, amount);
        }
        unchecked {
            balances[sender] = senderBalance - amount;
        }

        balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }
}
