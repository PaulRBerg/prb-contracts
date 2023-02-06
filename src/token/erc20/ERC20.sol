// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import { IERC20 } from "./IERC20.sol";

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
    mapping(address => uint256) internal _balances;

    /// @dev Internal mapping of allowances.
    mapping(address => mapping(address => uint256)) internal _allowances;

    /// CONSTRUCTOR ///

    /// @notice All three of these arguments are immutable: they can only be set once during construction.
    /// @param name_ ERC-20 name of this token.
    /// @param symbol_ ERC-20 symbol of this token.
    /// @param decimals_ ERC-20 decimal precision of this token.
    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
    }

    /// PUBLIC CONSTANT FUNCTIONS ///

    /// @inheritdoc IERC20
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /// PUBLIC NON-CONSTANT FUNCTIONS ///

    /// @inheritdoc IERC20
    function approve(address spender, uint256 value) public virtual override returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /// @inheritdoc IERC20
    function decreaseAllowance(address spender, uint256 value) public virtual override returns (bool) {
        // Calculate the new allowance.
        uint256 newAllowance = _allowances[msg.sender][spender] - value;

        // Make the approval.
        _approve(msg.sender, spender, newAllowance);
        return true;
    }

    /// @inheritdoc IERC20
    function increaseAllowance(address spender, uint256 value) public virtual override returns (bool) {
        // Calculate the new allowance.
        uint256 newAllowance = _allowances[msg.sender][spender] + value;

        // Make the approval.
        _approve(msg.sender, spender, newAllowance);
        return true;
    }

    /// @inheritdoc IERC20
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    /// @inheritdoc IERC20
    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        // Checks: the spender's allowance is sufficient.
        address spender = msg.sender;
        uint256 currentAllowance = _allowances[from][spender];
        if (currentAllowance < amount) {
            revert ERC20_InsufficientAllowance(from, spender, currentAllowance, amount);
        }

        // Effects: update the allowance.
        unchecked {
            _approve(from, spender, currentAllowance - amount);
        }

        // Checks, Effects and Interactions: make the transfer.
        _transfer(from, to, amount);

        return true;
    }

    /// INTERNAL NON-CONSTANT FUNCTIONS ///

    /// @notice Sets `value` as the allowance of `spender` over the `owner`s tokens.
    ///
    /// @dev Emits an {Approval} event.
    ///
    /// Requirements:
    ///
    /// - `owner` must not be the zero address.
    /// - `spender` must not be the zero address.
    function _approve(address owner, address spender, uint256 value) internal virtual {
        // Checks: `owner` is not the zero address.
        if (owner == address(0)) {
            revert ERC20_ApproveOwnerZeroAddress();
        }

        // Checks: `spender` is not the zero address.
        if (spender == address(0)) {
            revert ERC20_ApproveSpenderZeroAddress();
        }

        // Effects: update the allowance.
        _allowances[owner][spender] = value;

        // Emit an event.
        emit Approval(owner, spender, value);
    }

    /// @notice Destroys `amount` tokens from `holder`, decreasing the token supply.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// Requirements:
    ///
    /// - `holder` must have at least `amount` tokens.
    function _burn(address holder, uint256 amount) internal {
        // Checks: `holder` is not the zero address.
        if (holder == address(0)) {
            revert ERC20_BurnHolderZeroAddress();
        }

        // Effects: burn the tokens.
        _balances[holder] -= amount;

        // Effects: reduce the total supply.
        unchecked {
            // Underflow not possible: amount <= account balance <= total supply.
            totalSupply -= amount;
        }

        // Emit an event.
        emit Transfer(holder, address(0), amount);
    }

    /// @notice Prints new `amount` tokens into existence and assigns them to `beneficiary`, increasing the
    /// total supply.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// Requirements:
    ///
    /// - The beneficiary's balance and the total supply must not overflow.
    function _mint(address beneficiary, uint256 amount) internal {
        // Checks: `beneficiary` is not the zero address.
        if (beneficiary == address(0)) {
            revert ERC20_MintBeneficiaryZeroAddress();
        }

        /// Effects: increase the total supply.
        totalSupply += amount;

        /// Effects: mint the new tokens.
        unchecked {
            // Overflow not possible: `balance + amount` is at most `totalSupply + amount`, which is checked above.
            _balances[beneficiary] += amount;
        }

        // Emit an event.
        emit Transfer(address(0), beneficiary, amount);
    }

    /// @notice Moves `amount` tokens from `from` to `to`.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// Requirements:
    ///
    /// - `from` must not be the zero address.
    /// - `to` must not be the zero address.
    /// - `from` must have a balance of at least `amount`.
    function _transfer(address from, address to, uint256 amount) internal virtual {
        // Checks: `from` is not the zero address.
        if (from == address(0)) {
            revert ERC20_TransferFromZeroAddress();
        }

        // Checks: `to` is not the zero address.
        if (to == address(0)) {
            revert ERC20_TransferToZeroAddress();
        }

        // Checks: `from` has enough balance.
        uint256 fromBalance = _balances[from];
        if (fromBalance < amount) {
            revert ERC20_FromInsufficientBalance(fromBalance, amount);
        }

        // Effects: update the balance of `from` and `to`..
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by the total supply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        // Emit an event.
        emit Transfer(from, to, amount);
    }
}
