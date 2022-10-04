pragma solidity ^0.4.24;
/* 
    Task2:
    Start Implementing ERC20 contract Methods. 

    Initialize the contract with ABI json and
    Call the Contract Public Available Methods of Read and Write with Arguments

    0xEcB30Ad03f71D977051c5B59b459b0034d207e40
    Binance Smart Chain Contract Address Mainne

    Purpose:
        1. To understand the structure of ERC20 Standard
        2. To get familiar with Solidity
*/

/*
    SafeMath is a Solidity library aimed at dealing with one way hackers
    have been known to break contracts: integer overflow attack. In such
    an attack, the hacker forces the contract to use incorrect numeric 
    values by passing parameters that will take the relevant integers past their maximal values. 
*/

/*
    1. A public function can be accessed outside of the contract itself
    2. view basically means constant, i.e. the contract’s internal state will not be changed by the
    function 
    3. An event is Solidity’s way of allowing clients e.g. your application frontend to be
    notified on specific occurrences within the contract
*/

/*
    Solidity assert and require are convenience functions
    that check for conditions. In cases when conditions are not met,
    they throw exceptions

    These are the cases when Solidity creates assert-type of exceptions:

    When you invoke Solidity assert with an argument, showing false.
    When you invoke a zero-initialized variable of an internal function type.
    When you convert a large or negative value to enum.
    When you divide or modulo by zero.
    When you access an array in an index that is too big or negative.

    In the following cases, Solidity triggers a require-type of exception:

    When you call require with arguments that result in false.
    When a function called through a message does not end properly.
    When you create a contract with new keyword and the process does not end properly.
    When you target a codeless contract with an external function.
    When your contract gets Ether through a public getter function.
    When .transfer() ends in failure.
*/

//Safe Math Interface 
contract SafeMath {
    // View promise not to modify the state
    // Pure promise not to modify or read from the state.
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
 
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
 
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
 
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
 
 
//ERC Token Standard #20 Interface
contract ERC20Interface {
    // TotalSupply: provides information about the total token supply
    function totalSupply() public constant returns (uint);
    // BalanceOf: provides account balance of the owner's account
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    // Allowance: returns a set number of tokens from a spender to the owner
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    // Transfer: executes transfers of a specified number of tokens to a specified address
    function transfer(address to, uint tokens) public returns (bool success);
    // Approve: allow a spender to withdraw a set number of tokens from a specified account
    function approve(address spender, uint tokens) public returns (bool success);
    // TransferFrom: executes transfers of a specified number of tokens from a specified address
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);
}
 
 
//Contract function to receive approval and execute function in one call
 
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}
 
//Actual token contract
 
contract BTCToken is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    address public  walletAddress;
    uint8 public decimals;
    uint public _totalSupply;
 
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
 
    constructor() public {
        walletAddress = 0xEcB30Ad03f71D977051c5B59b459b0034d207e40;
        symbol = "BTC";
        name = "Binance Smart Chain Contract";
        decimals = 2;
        _totalSupply = 100000;
        balances[walletAddress] = _totalSupply;
        emit Transfer(address(0), walletAddress, _totalSupply);
    }
 
    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }
 
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }
 
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
 
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
 
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
 
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
 
    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }
 
    function () public payable {
        revert();
    }
}