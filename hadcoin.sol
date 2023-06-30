// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ICO {
    string public name = "Example ICO";
    uint256 public totalSupply;
    uint256 public tokenPrice;
    address payable public wallet;
    mapping(address => uint256) public balances;

    event TokensPurchased(address indexed buyer, uint256 amount);
    event TokensSold(address indexed seller, uint256 amount);

    constructor(uint256 initialSupply, uint256 pricePerToken, address payable walletAddress) {
        totalSupply = initialSupply;
        tokenPrice = pricePerToken;
        wallet = walletAddress;
    }

    function buyTokens() public payable {
        require(msg.value > 0, "You must send some Ether to purchase tokens.");

        uint256 tokensToBuy = msg.value / tokenPrice;
        require(tokensToBuy > 0 && balances[address(this)] >= tokensToBuy, "Insufficient token supply.");

        balances[address(this)] -= tokensToBuy;
        balances[msg.sender] += tokensToBuy;

        wallet.transfer(msg.value);
        emit TokensPurchased(msg.sender, tokensToBuy);
    }

    function sellTokens(uint256 amount) public {
        require(amount > 0 && balances[msg.sender] >= amount, "Insufficient token balance.");

        uint256 saleValue = amount * tokenPrice;
        balances[msg.sender] -= amount;
        balances[address(this)] += amount;

        payable(msg.sender).transfer(saleValue);
        emit TokensSold(msg.sender, amount);
    }
}
