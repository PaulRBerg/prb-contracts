// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "./IERC20.sol";

/// @title ERC20
/// @author Paul Razvan Berg
contract ERC20 is IERC20 {
    /// PUBLIC STORAGE ///

    /// @inheritdoc IERC20
    string public override name;

    /// @inheritdoc IERC20
    string public override symbol;

    /// @inheritdoc IERC20
    uint8 public immutable override decimals;

    /// @inheritdoc IERC20
    uint256 public override totalSupply;

    /// INTERNAL STORAGE ///

    /// @dev Internal mapping of balances.
    mapping(address => uint256) internal balances;

    /// @dev Internal mapping of allowances.
    mapping(address => mapping(address => uint256)) internal allowances;

    /// CONSTRUCTOR ///

    /// @notice All three of these arguments are immutable: they can only be set once during construction.
    /// @param name_ ERC-20 name of this token.
    /// @param symbol_ ERC-20 symbol of this token.
    /// @param decimals_ ERC-20 decimal precision of this token.
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

    /// @inheritdoc IERC20
    function allowance(address owner, address spender) public view override returns (uint256) {
        return allowances[owner][spender];
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return balances[account];
    }

    /// PUBLIC NON-CONSTANT FUNCTIONS ///

    /// @inheritdoc IERC20
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        approveInternal(msg.sender, spender, amount);
        return true;
    }

    /// @inheritdoc IERC20
    function decreaseAllowance(address spender, uint256 subtractedAmount) public virtual override returns (bool) {
        uint256 newAllowance = allowances[msg.sender][spender] - subtractedAmount;
        approveInternal(msg.sender, spender, newAllowance);
        return true;
    }

    /// @inheritdoc IERC20
    function increaseAllowance(address spender, uint256 addedAmount) public virtual override returns (bool) {
        uint256 newAllowance = allowances[msg.sender][spender] + addedAmount;
        approveInternal(msg.sender, spender, newAllowance);
        return true;
    }

    /// @inheritdoc IERC20
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        transferInternal(msg.sender, recipient, amount);
        return true;
    }

    /// @inheritdoc IERC20
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        transferInternal(sender, recipient, amount);

        uint256 currentAllowance = allowances[sender][msg.sender];
        if (currentAllowance < amount) {
            revert ERC20__InsufficientAllowance(currentAllowance, amount);
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
            revert ERC20__ApproveOwnerZeroAddress();
        }
        if (spender == address(0)) {
            revert ERC20__ApproveSpenderZeroAddress();
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
            revert ERC20__BurnZeroAddress();
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
            revert ERC20__MintZeroAddress();
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
            revert ERC20__TransferSenderZeroAddress();
        }
        if (recipient == address(0)) {
            revert ERC20__TransferRecipientZeroAddress();
        }

        uint256 senderBalance = balances[sender];
        if (senderBalance < amount) {
            revert ERC20__InsufficientBalance(senderBalance, amount);
        }
        unchecked {
            balances[sender] = senderBalance - amount;
        }

        balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }
}
