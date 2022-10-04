pragma solidity ^0.8.2;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./VenderToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller,uint256 amountOfETH, uint256 amountOfTokens);

  uint256 public constant tokensPerEth = 100;
  uint256 public pricePerToken = 10**18/100;

  VenderToken public venderToken;

  constructor(address tokenAddress) {
    venderToken = VenderToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable{
      uint256 amountOfTokens = msg.value/pricePerToken;
      venderToken.transfer(msg.sender,amountOfTokens);
      emit BuyTokens(msg.sender,msg.value,amountOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner{
    payable(address(owner())).transfer(address(this).balance);
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public {
    uint256 priceOfTokens = pricePerToken*_amount;
    //checking if vender has enough eth for buying tokens
    require(address(this).balance >= priceOfTokens,"vendor don't have enough eth");
    //seller must approve vendor to receive his tokens then vender
    //can call transferFrom receive tokens and donate eth
    venderToken.transferFrom(msg.sender,address(this),_amount);
    //transfer amount to seller
    payable(address(msg.sender)).transfer(priceOfTokens);
    emit SellTokens(msg.sender,priceOfTokens,_amount);
  }

  function contractBal() public view returns (uint256 balance){
    return address(this).balance;
  }
}