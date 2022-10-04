/*
    🏦 Build a Staker.sol contract that collects ETH from numerous addresses using a payable stake() 
    function and keeps track of balances. After some deadline if it has at least some threshold 
    of ETH, it sends it to an ExampleExternalContract and triggers the complete() action sending the
    full balance. If not enough ETH is collected, allow users to withdraw().
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "./ExampleExternalContract.sol";

contract Staker{
    mapping(address => uint) balances;
    mapping(uint => address) owners;
    uint currentNumberOfOwner = 0;
    bool openForWithdraw = false;
    uint public constant threshold = 1 ether;
    uint public deadline = block.timestamp + 30 seconds;
    event Stake(address indexed owner, uint indexed balance);
    event Withdraw(address indexed owner, uint indexed withdrawnAmount);
    ExampleExternalContract public exampleExternalContract;

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    }

    modifier _exists(address owner)
    {
        require(owner != address(0), "Owner doesnt exist");
        _;
    }
    function balanceOf(address owner) public view _exists(owner) returns(uint)
    {
        return balances[owner];
    }

    modifier checkBalance(uint balance)
    {
        require(balance < threshold, "Threshold has crossed the limit");
        _;
    }

    // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
    // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
    function stake(address owner, uint balance) public payable _exists(owner) checkBalance(balance)
    {
        owners[currentNumberOfOwner] = owner;
        currentNumberOfOwner++;
        balances[owner] += balance;
        emit Stake(owner, balance);
    }

    // After some `deadline` allow anyone to call an `execute()` function
    modifier checkDeadline()
    {
        require(timeLeft() == 0, "Function cannot be executed as it hasnt passed the deadline!");
        _;
    }

    // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
    function execute() public payable checkDeadline() returns(bool)
    {
        exampleExternalContract.complete();
        openForWithdraw = true;
        return true;
    }

    // If the `threshold` was not met, allow everyone to call a `withdraw()` function
    modifier checkIfOpenForWithDraw()
    {
        require(openForWithdraw == true, "Amount cannot be withdrawn until execute function is called!");
        _;
    }

    modifier checkWithDrawAmount(address user, uint amount)
    {
        require(balances[user] >= amount, "Withdraw amount exceeds the limit of the account!");
        _;
    }

    // Add a `withdraw()` function to let users withdraw their balance
    function withdraw(address user, uint amount) public _exists(user) checkIfOpenForWithDraw() checkBalance(amount) checkWithDrawAmount(user, amount) returns(uint)
    {
        balances[user] -= amount;
        emit Withdraw(user, amount);
        return amount;
    }
    

    // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
    function timeLeft() public view returns(uint)
    {
        if(block.timestamp >= deadline)
            return 0;
        return (deadline - block.timestamp);       
    }

    // Add the `receive()` special function that receives eth and calls stake()
    function receive(uint amount) public returns(bool)
    {
        stake(msg.sender, amount);
        return true;
    }
}