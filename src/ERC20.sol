// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ERC20{
    
    uint256 private S_totalSupply;
    mapping(address => uint256) private S_balances;
    mapping(address => mapping(address => uint256)) private S_allowances;
    string private S_name = "MYERC20";
    string private S_symbol = "TKN";
    uint8 private S_decimals = 18;
    address owner;

    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender,  uint256 value);


    constructor (uint256 _totalSupply){
        owner = msg.sender;
        S_totalSupply = _totalSupply;
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(value >= 0, "Value must be greater than 0");
        require(S_balances[msg.sender] >= value, "Insufficient balance");
        S_balances[msg.sender] = S_balances[msg.sender] - value;
        S_balances[to] = S_balances[msg.sender] + value;
        emit Transfer(msg.sender, to, value);
        return true;

    }

    function approve(address spender, uint256 value) public returns (bool) {
        S_allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(value >= 0, "Value must be greater than 0");
        require(S_balances[from] >= value, "Insufficient balance");
        require(S_allowances[from][msg.sender] >= value, "Allowance exceeded");
        S_balances[from] = S_balances[from] - value;
        S_balances[to] = S_balances[to] + value;
        S_allowances[from][msg.sender] = S_allowances[from][msg.sender] - value;
        emit Transfer(from, to, value);
        return true;
    }

    
    function allowances(address _owner, address _spender) public view returns(uint256) {
        return S_allowances[_owner][_spender];
    }

    function balanceOf(address user) public view returns(uint256) {
        return S_balances[user];
    }

    function name() public view returns (string memory)  {
        return S_name;
    }

    function symbol() public view returns (string memory) {
        return S_symbol;
    }

    function decimals() public view returns (uint8)  {
        return S_decimals;
    }

    function totalSupply() public view returns (uint256) {
        return  S_totalSupply;
    }

    function mint(address _to, uint256 amount) public returns(bool) {
        require(msg.sender == owner, "You are Not the Owner");
        require(S_totalSupply >= amount);
        S_balances[_to] =  S_balances[_to] + amount; 
        emit Transfer(address(0), _to, amount);
        return true;
    }
}
