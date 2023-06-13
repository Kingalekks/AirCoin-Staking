// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract AirCoinStaking {
    string public name = "AirCoin Staking";
    string public symbol = "AIR";

    uint256 private totalSupply;
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    mapping(address => uint256) private stakes;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Staked(address indexed staker, uint256 amount);
    event Unstaked(address indexed staker, uint256 amount);

    constructor() {
        totalSupply = 10000000000; // Total supply of AirCoin
        balances[msg.sender] = totalSupply; // Assign all tokens to the contract deployer
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(amount > 0, "Amount must be greater than zero");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        require(amount > 0, "Amount must be greater than zero");
        require(amount <= balances[msg.sender], "Insufficient balance");

        allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(amount > 0, "Amount must be greater than zero");
        require(amount <= balances[sender], "Insufficient balance");
        require(amount <= allowances[sender][msg.sender], "Insufficient allowance");

        balances[sender] -= amount;
        balances[recipient] += amount;
        allowances[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    function stake(uint256 amount) public returns (bool) {
        require(amount > 0, "Amount must be greater than zero");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= amount;
        stakes[msg.sender] += amount;

        emit Staked(msg.sender, amount);
        return true;
    }

    function unstake(uint256 amount) public returns (bool) {
        require(amount > 0, "Amount must be greater than zero");
        require(amount <= stakes[msg.sender], "Insufficient stake");

        stakes[msg.sender] -= amount;
        balances[msg.sender] += amount;

        emit Unstaked(msg.sender, amount);
        return true;
    }

    function stakeOf(address account) public view returns (uint256) {
        return stakes[account];
    }
}
