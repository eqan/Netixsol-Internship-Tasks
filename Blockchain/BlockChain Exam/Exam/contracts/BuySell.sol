// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "./UserToken.sol";

contract BuySell
{
    uint256 public constant pricePerToken = 0.0000000000000001 ether;
    UserToken public userToken;

    mapping(address => uint) private boughtTokens;
    mapping(address => uint) private balance;
    
    event BuyTokens(address buyer, uint256 amountOfTokens);
    event SellTokens(address vendor, address owner, uint256 amountOfTokens);

    constructor(address tokenAddress)
    {
        userToken = UserToken(tokenAddress);
    }

    modifier checkPrice(uint price)
    {
      require(price >= pricePerToken, "Price should be equal to or greater than 1 token price");
      _;
    }

    modifier checkTokens(uint amount)
    {
      require(amount >= 1, "Tokens should be greater than or equal to 1");
      _;
    }

    function buyTokens(uint price) public checkPrice(price) payable
    {
        uint amount = price / pricePerToken;
        
        boughtTokens[msg.sender] += amount;
        balance[msg.sender] -= price;

        boughtTokens[address(this)] -= amount;
        balance[address(this)] += price;

        userToken.approve(msg.sender, amount);
        userToken.transfer(msg.sender, amount);
        emit BuyTokens(msg.sender, amount);
    }


    function sellTokens(uint amount) public checkTokens(amount) payable
    {
        uint price = amount * pricePerToken;
        userToken.approve(msg.sender, amount);

        boughtTokens[msg.sender] -= amount;
        balance[msg.sender] += price;

        boughtTokens[address(this)] += amount;
        balance[address(this)] -= price;

        userToken.transferFrom(msg.sender, address(this), amount);
        payable(address(msg.sender)).transfer(amount);
        emit SellTokens(msg.sender, address(this), amount);
    }

    function getNumberOfTokens() external view returns(uint)
    {
        return boughtTokens[msg.sender];
    }

    function convertToXCurrency(uint tokensAmount) external pure returns(uint)
    {
        return (tokensAmount * pricePerToken);
    }

}