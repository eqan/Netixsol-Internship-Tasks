// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "./BuySell.sol";

contract Stake
{
   struct MetaData
    {
        uint tokens;
        uint reward;
    }

    uint private intitialBlockNumber = 0;
    uint private countUsers = 0;
    BuySell public buySellToken;
 
    mapping(address => MetaData) stakers;
    mapping(uint => address) stakersIDs;

    modifier checkStakeAmount(uint amount)
    {
        require(amount <= buySellToken.getNumberOfTokens(), "Number of tokens to be staked exceed the amount limit!");
        _;
    }

    constructor(address tokenAddress) {
        buySellToken = BuySell(tokenAddress);
        intitialBlockNumber = block.number;
        stakersIDs[countUsers] = tokenAddress;
        countUsers++;
    }

    function stake(address userAddress, uint amount) public checkStakeAmount(amount)
    {
        if(!checkUserAlreadyExists(userAddress))
        {
            stakersIDs[countUsers] = userAddress;
            countUsers++;
        }
        uint reward = ((intitialBlockNumber - block.number)/countUsers) * amount;
        stakers[userAddress].tokens += amount;

        for(uint i=0; i < countUsers; i++)
        {
            stakers[stakersIDs[i]].reward += reward;
        }
    }

    function unstake(address userAddress) public returns(uint)
    {
        uint total = stakers[userAddress].tokens + stakers[userAddress].reward;
        stakers[userAddress].tokens = 0;
        stakers[userAddress].reward = 0;
        return buySellToken.convertToXCurrency(total);
    }

    function claim(address userAddress) public returns(uint)
    {
        uint reward = stakers[userAddress].reward;
        stakers[userAddress].reward = 0;
        return buySellToken.convertToXCurrency(reward);
    }

    function checkUserAlreadyExists(address userAddress) private view returns(bool)
    {
        for(uint i=0; i < countUsers; i++)
        {
            if(stakersIDs[i] ==  userAddress)
                return true;
        }
        return false;
    }
}