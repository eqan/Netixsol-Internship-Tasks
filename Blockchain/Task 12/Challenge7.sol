// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/*
    Create a smart contract, send and withdraw ethers.
    All you need to know is PAYABLE.
    A function needs to be of the payable type in order to be able to receive ethers.
    What if the function isn’t payable? It will sadly refuse to accept the ethers and the
    transaction will be reverted. Want the contract to accept Ethers no matter what?
    Fallback functions make it possible
    You can send ethers by simply exploring this awesome Article and learn about the
    different ways to handle this case!
*/

contract SendAndWithdrawEthers
{
    uint usersCount=0;
    mapping (address => uint) userToAmount;
    mapping (uint => address) usersRecord;

    event entrySuccess (uint usersCount, address userAddress);
    event ethersDepositSuccess(address userAddress, uint amount);
    event ethersSendSuccess(address from, address to, uint amount);
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

    function makeEntry () public
    {
        usersRecord[usersCount] = msg.sender;
        emit entrySuccess(usersCount, msg.sender);
    }

    function depositEthers () public payable {
        userToAmount[msg.sender] = msg.value;
        emit ethersDepositSuccess(msg.sender, msg.value);
    }

    function send(address _to, uint _amount) public payable checkAmountSufficientForTransaction(msg.sender, _amount)
    {
        payable(address(_to)).transfer(_amount);
        address _from = msg.sender;        
        
        userToAmount[_from] = userToAmount[_from] - _amount;
        userToAmount[_to] = userToAmount[_to] + _amount;

        emit ethersSendSuccess(_from, _to, _amount);
    }

    function withdraw(uint _amount) public payable checkAmountSufficientForTransaction(msg.sender, _amount) checkUserIsValid()
    {
        address userAddress = msg.sender;
        payable(userAddress).transfer(_amount);
    
        uint leftoverAmount = userToAmount[userAddress];
        userToAmount[userAddress] = leftoverAmount - _amount;

        emit ethersWithdrawSuccess(userAddress, leftoverAmount);
    }   
}