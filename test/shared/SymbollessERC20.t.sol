// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

contract SymbollessERC20 {
    uint8 public decimals;

    string public name;

    uint256 public totalSupply;

    mapping(address => mapping(address => uint256)) internal allowances;

    mapping(address => uint256) internal balances;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    constructor(string memory name_, uint8 decimals_) {
        name = name_;
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

    function transfer(address to, uint256 amount) public returns (bool) {
        transferInternal(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        transferInternal(from, to, amount);
        approveInternal(from, msg.sender, allowances[from][msg.sender] - amount);
        return true;
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
