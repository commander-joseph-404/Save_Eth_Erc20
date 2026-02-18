// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import {ERC20} from "src/ERC20.sol";

contract SaveEtherErc20{


    mapping(address => uint256) private ethBalances;

    mapping(address => uint256) private tokenBalances;

    address tokenAddress;

   
    event EtherDeposited(address indexed user, uint256 amount);
    event EtherWithdrawn(address indexed user, uint256 amount);

    event TokenDeposited(
        address indexed user,
        address indexed token,
        uint256 amount
    );

    event TokenWithdrawn(
        address indexed user,
        address indexed token,
        uint256 amount
    );

    constructor (address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }


    function depositEther() external payable {
        require(msg.value > 0, "Must send ETH");
        ethBalances[msg.sender] += msg.value;
        emit EtherDeposited(msg.sender, msg.value);
    }

   
    function getEtherBalance(address user) external view returns (uint256) {
        return ethBalances[user];
    }

  
    function withdrawEther(uint256 amount) external {
        require(ethBalances[msg.sender] >= amount, "Insufficient balance");

        ethBalances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value:amount}("");

        require(success, "Withdrawal Not Successful");
        emit EtherWithdrawn(msg.sender, amount);
    }

    /*//////////////////////////////////////////////////////////////
                            ERC20 FUNCTIONS
    //////////////////////////////////////////////////////////////*/

  
    function depositToken(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        ERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);

        tokenBalances[msg.sender] = tokenBalances[msg.sender] + amount;
    }

    function getTokenBalance(address user) external view returns (uint256) {
        return tokenBalances[user];
    }

    // Withdraw ERC20 tokens
    function withdrawToken( uint256 amount) external {
        require(tokenBalances[msg.sender] >= amount, "Insufficient balance");

        tokenBalances[msg.sender] =  tokenBalances[msg.sender]  - amount;

        bool success = ERC20(tokenAddress).transfer(msg.sender, amount);
        require(success, "Withdrawal Not Successful");
    }
}




