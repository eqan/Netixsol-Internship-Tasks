// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Transaction is ERC20 {
    constructor(
    uint256 _amount
  )
  ERC20("Bitcoin", "BTC")
    {
        _transfer(msg.sender, _amount);
        
    }
}