// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "../../interfaces/IErc20.sol";

/// @title Erc20
/// @author Paul Razvan Berg
/// @notice Implementation of the {IErc20} interface.
///
/// We have followed general OpenZeppelin guidelines: functions revert instead of returning
/// `false` on failure. This behavior is nonetheless conventional and does not conflict with
/// the with the expectations of Erc20 applications.
///
/// Additionally, an {Approval} event is emitted on calls to {transferFrom}. This allows
/// applications to reconstruct the allowance for all accounts just by listening to said
/// events. Other implementations of the Erc may not emit these events, as it isn't
/// required by the specification.
///
/// Finally, the non-standard {decreaseAllowance} and {increaseAllowance} functions have been
/// added to mitigate the well-known issues around setting allowances.
///
/// @dev Forked from OpenZeppelin
/// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.4.0/contracts/token/ERC20/ERC20.sol
contract Erc20 is IErc20 {
    /// @inheritdoc IErc20
    string public override name;

    /// @inheritdoc IErc20
    string public override symbol;

    /// @inheritdoc IErc20
    uint8 public immutable override decimals;

    /// @inheritdoc IErc20
    uint256 public override totalSupply;

    /// @inheritdoc IErc20
    mapping(address => uint256) public override balanceOf;

    /// @inheritdoc IErc20
    mapping(address => mapping(address => uint256)) public override allowance;

    /// @notice All three of these values are immutable: they can only be set once during construction.
    /// @param _name Erc20 name of this token.
    /// @param _symbol Erc20 symbol of this token.
    /// @param _decimals Erc20 decimal precision of this token.
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    /// @inheritdoc IErc20
    function approve(address spender, uint256 amount) external virtual override returns (bool) {
        approveInternal(msg.sender, spender, amount);
        return true;
    }

    /// @inheritdoc IErc20
    function decreaseAllowance(address spender, uint256 subtractedValue) external virtual override returns (bool) {
        uint256 newAllowance = allowance[msg.sender][spender] - subtractedValue;
        approveInternal(msg.sender, spender, newAllowance);
        return true;
    }

    /// @inheritdoc IErc20
    function increaseAllowance(address spender, uint256 addedValue) external virtual override returns (bool) {
        uint256 newAllowance = allowance[msg.sender][spender] + addedValue;
        approveInternal(msg.sender, spender, newAllowance);
        return true;
    }

    /// @inheritdoc IErc20
    function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
        transferInternal(msg.sender, recipient, amount);
        return true;
    }

    /// @inheritdoc IErc20
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external virtual override returns (bool) {
        transferInternal(sender, recipient, amount);

        uint256 currentAllowance = allowance[sender][msg.sender];
        require(currentAllowance >= amount, "ERC20_TRANSFER_FROM_INSUFFICIENT_ALLOWANCE");
        approveInternal(sender, msg.sender, currentAllowance);
        return true;
    }

    /// INTERNAL FUNCTIONS ///

    /// @notice Sets `amount` as the allowance of `spender` over the `owner`s tokens.
    ///
    /// @dev Emits an {Approval} event.
    ///
    /// This is internal function is equivalent to `approve`, and can be used to e.g. set automatic
    /// allowances for certain subsystems, etc.
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
        require(owner != address(0), "ERC20_APPROVE_FROM_ZERO_ADDRESS");
        require(spender != address(0), "ERC20_APPROVE_TO_ZERO_ADDRESS");

        allowance[owner][spender] = amount;
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
        require(holder != address(0), "ERC20_BURN_ZERO_ADDRESS");

        uint256 accountBalance = balanceOf[holder];
        require(accountBalance >= burnAmount, "ERC20_BURN_BALANCE_UNDERFLOW");

        // Burn the tokens.
        balanceOf[holder] = accountBalance - burnAmount;

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
        require(beneficiary != address(0), "ERC20_MINT_ZERO_ADDRESS");

        /// Mint the new tokens.
        balanceOf[beneficiary] += mintAmount;

        /// Increase the total supply.
        totalSupply += mintAmount;

        emit Transfer(address(0), beneficiary, mintAmount);
    }

    /// @notice Moves `amount` tokens from `sender` to `recipient`.
    ///
    /// @dev This is internal function is equivalent to {transfer}, and can be used to e.g. implement
    /// automatic token fees, slashing mechanisms, etc.
    ///
    /// Emits a {Transfer} event.
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
        require(sender != address(0), "ERC20_TRANSFER_FROM_ZERO_ADDRESS");
        require(recipient != address(0), "ERC20_TRANSFER_TO_ZERO_ADDRESS");

        uint256 senderBalance = balanceOf[sender];
        require(senderBalance >= amount, "ERC20_TRANSFER_INSUFFICIENT_BALANCE");
        balanceOf[sender] = senderBalance - amount;
        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }
}
