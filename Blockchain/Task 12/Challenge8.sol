// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/* 
    Create a smart contract to store ethers in it. But you already did that in challenge 3.
    Here is what you have to do, make it so that the user can’t withdraw them before a
    specific time.
    Each block in the blockchain includes a timestamp!
    Timestamp is specified as the number of seconds since the Unix epoch.
    Unix epoch hmmm sounds complex? But only seconds have passed since 1st
    January 1970.
    Solidity made it easy to access timestamps. The answer lies in block.timestamp.
    The concept of timestamp is really important for solidity and since you completed this
    challenge, kudos to you! You have learned about timestamps.
    You can find the current UNIX timestamp here
*/
contract StoreEthers
{
    uint usersCount=0;
    mapping (address => uint) userToAmount;
    mapping (uint => address) usersRecord;
    mapping (address => uint) usersDepositTime;

    event entrySuccess (uint usersCount, address userAddress);
    event ethersDepositSuccess(address userAddress, uint amount);
    event ethersWithdrawSuccess(address userAddress, uint leftAmount);

    modifier checkAmountSufficientForTransaction(address userAddress, uint _amount)
    {
        uint specificUserAmount = userToAmount[userAddress];
        require(_amount <= specificUserAmount, "Insufficient balance");
        _;
    }

    modifier checkUserIsValid()
    {
        require(msg.sender != address(0), "invalid wallet address");
        _;
    }

    modifier checkTimeLimit()
    {
        require(usersDepositTime[msg.sender] < block.timestamp, "Currently amount can't be withdrawn before the time limit!");
        _;
    }

    function makeEntry () public
    {
        usersRecord[usersCount] = msg.sender;
        emit entrySuccess(usersCount, msg.sender);
    }

    function depositEthers () public payable {
        userToAmount[msg.sender] = msg.value;
        usersDepositTime[msg.sender] = block.timestamp + 30;
        emit ethersDepositSuccess(msg.sender, msg.value);
    }

    function withdraw(uint _amount) public payable checkAmountSufficientForTransaction(msg.sender, _amount) checkUserIsValid() checkTimeLimit()
    {
        address userAddress = msg.sender;
        payable(userAddress).transfer(_amount);
    
        uint leftoverAmount = userToAmount[userAddress];
        userToAmount[userAddress] = leftoverAmount - _amount;
        usersDepositTime[userAddress] = usersDepositTime[userAddress] + 30;

        emit ethersWithdrawSuccess(userAddress, leftoverAmount);
    }   
}