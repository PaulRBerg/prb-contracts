// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

/// @title NonCompliantERC20
/// @author Paul Razvan Berg
/// @notice An implementation of ERC-20 that does not return a boolean on `transfer` and `transferFrom`.
/// @dev Strictly for test purposes. Do not use in production.
/// https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
contract NonCompliantERC20 {
    uint8 public decimals;

    string public name;

    string public symbol;

    uint256 public totalSupply;

    mapping(address => mapping(address => uint256)) internal allowances;

    mapping(address => uint256) internal balances;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        approveInternal(msg.sender, spender, amount);
        return true;
    }

    function burn(address holder, uint256 amount) public {
        balances[holder] -= amount;
        totalSupply -= amount;
        emit Transfer(holder, address(0), amount);
    }

    function mint(address beneficiary, uint256 amount) public {
        balances[beneficiary] += amount;
        totalSupply += amount;
        emit Transfer(address(0), beneficiary, amount);
    }

    /// @dev This function does not return a value, in violation of the ERC-20 standard.
    function transfer(address to, uint256 amount) public {
        transferInternal(msg.sender, to, amount);
    }

    /// @dev This function does not return a value, in violation of the ERC-20 standard.
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public {
        transferInternal(from, to, amount);
        approveInternal(from, msg.sender, allowances[from][msg.sender] - amount);
    }

    function transferInternal(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        balances[from] = balances[from] - amount;
        balances[to] = balances[to] + amount;
        emit Transfer(from, to, amount);
    }

    function approveInternal(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
