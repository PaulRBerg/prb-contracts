// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

contract SymbollessERC20 {
    uint8 public decimals;

    string public name;

    uint256 public totalSupply;

    mapping(address => mapping(address => uint256)) internal _allowances;

    mapping(address => uint256) internal _balances;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    constructor(string memory name_, uint8 decimals_) {
        name = name_;
        decimals = decimals_;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function burn(address holder, uint256 amount) public {
        _balances[holder] -= amount;
        totalSupply -= amount;
        emit Transfer(holder, address(0), amount);
    }

    function mint(address beneficiary, uint256 amount) public {
        _balances[beneficiary] += amount;
        totalSupply += amount;
        emit Transfer(address(0), beneficiary, amount);
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        _transfer(from, to, amount);
        _approve(from, msg.sender, _allowances[from][msg.sender] - amount);
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        _balances[from] = _balances[from] - amount;
        _balances[to] = _balances[to] + amount;
        emit Transfer(from, to, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
