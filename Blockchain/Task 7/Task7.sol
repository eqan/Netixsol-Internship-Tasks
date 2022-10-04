//SPDX-License-Identifier:MIT
pragma solidity ^0.8.5;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// Built using Built in functions
contract Token is ERC20PresetMinterPauser{
// Built using B
    constructor(string memory _name, string memory _symbol, uint256 initialSupply) ERC20PresetMinterPauser(_name, _symbol)
    {
    }

    function _mint(uint256 initialSupply) public virtual
    {
        mint(msg.sender, initialSupply);
    }

    function _burn(uint256 initialSupply) public virtual
    {
        burnFrom(msg.sender, initialSupply);
    }
}

// Built From Scratch
contract GLDToken is ERC20{
    uint256 _totalSupply;
    mapping(address => uint256) public _balanceOf;
    constructor(uint256 initialSupply) ERC20("Gold", "GLD") {
        _totalSupply = initialSupply;
        mint(msg.sender, initialSupply);
        burn(msg.sender, initialSupply);
    }
  

    function mint(address account, uint256 amount) public virtual{
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply += amount;
        _balanceOf[account] += amount;
        emit Transfer(address(0), account, amount);
    }
    function burn(address account, uint256 amount) public virtual{
        require(account != address(0), "ERC20: burn to the zero address");
        _totalSupply -= amount;
        _balanceOf[account] -= amount;
        emit Transfer(address(0), account, amount);
    }
}