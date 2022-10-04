/*
    Make an ERC20 token contract. The token will have a capped supply of 100M. 10M will be pre minted. The other 90M will be minted anytime by the owner of contract. 
    We have to sell these tokens for some price. The initial price of token will be 0.00001 ETH. 
    Owner of contract can change price anytime. Owner will be able to withdraw the eth amount. 
    Whenever user will buy tokens it will charge some fee from buy amount. The initial fee is 0.1%. But the owner of contract can change the fee anytime. 
    Write proper tests for every function. 
*/
// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a, "Safe Add: Value Overflowed!");
    }
 
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a, "Safe Sub Error: Value Underflowed");
        c = a - b;
    }
 
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b, "Safe Mul Error");
    }
 
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b > 0, "Safe Div Error: Denominator is 0");
        c = a / b;
    }
}
 

//ERC Token Standard #20 Interface
abstract contract  ERC20Interface {
    // TotalSupply: provides information about the total token supply
    function  TotalSupply() public virtual  returns (uint);
    // BalanceOf: provides account balance of the owner's account
    function BalanceOf(address user) public virtual returns (uint balance);
    // Allowance: returns a set number of tokens from a spender to the owner
    function Allowance(address user, address spender) public virtual returns (uint remaining);
    // Transfer: executes transfers of a specified number of tokens to a specified address
    function Transfer(address to, uint tokens) public virtual returns (bool success);
    // Approve: allow a spender to withdraw a set number of tokens from a specified account
    function Approve(address spender, uint tokens) public virtual returns (bool success);
    // TransferFrom: executes transfers of a specified number of tokens from a specified address
    function TransferFrom(address from, address to, uint tokens) public virtual returns (bool success);
    // approval: activated whenever approval is required.
    event approval(address indexed user, address indexed spender, uint tokens);
    // transfer: that takes place whenever tokens are transferred
    event transfer(address indexed from, address indexed to, uint tokens);
}
 
  
//Actual token contract
contract ExamQ1 is ERC20Interface, SafeMath, Ownable{
    string public symbol;
    string public  name;
    uint constant private decimals = 8;
    uint private _totalSupply;
    uint private _cappedSupply;
    uint private _sellingPrice = 0.00001 ether;
    uint private _buyFees = 0;
 
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    // To check if both sides agree for transaction
    mapping(address => mapping(address => uint)) allowedBuy;
    mapping(address => mapping(address => uint)) allowedSell;

    modifier checkLimit(address user, uint _amount)
    {
        require((_amount + balances[user]) <= _cappedSupply, "The amount has exceeded the cap limit");
        _;
    }

    modifier checkTransactionApprovedFromBothSides(address userBuyer, address userSeller, uint _amount)
    {
        uint buyerAmount = allowedBuy[userBuyer][userSeller];
        uint sellerAmount = allowedSell[userSeller][userBuyer];
        require(buyerAmount == sellerAmount, "Transaction cannot be commited as there is a dispute!");
        _;
    }

    
    modifier validateWithdrawAmount(address user, uint _amount)
    {
        require((balances[user] - _amount) >= 0, "You donot have enough amount to withdraw!");
        _;
    }
    // modifier checkSymbolAndName(string memory symbol_, string memory name_)
    // {
    //     //require(symbol_ != "" && name_ != "", "Symbol or name cant be empty");
    //     _;
    // }
 
    constructor(string memory symbol_,string memory name_) 
    {
        symbol = symbol_;
        name = name_;
        _cappedSupply =  10 ** decimals;
        uint preMinted = 10 ** (decimals - 1);
        Mint(preMinted);
    }

    function TotalSupply() public view override returns (uint) {
        return _totalSupply;
    }
 
    function BalanceOf(address user) public view override returns (uint balance) {
        return balances[user];
    }

    function Transfer(address to, uint tokens) public override returns (bool success) {
        return _transfer(to, tokens);
    }

    function Approve(address spender, uint tokens) public override returns (bool success) {
        return _approve(spender, tokens);
    }

    function TransferFrom(address from, address to, uint tokens) public override returns (bool success) {
        return _transferFrom(from, to, tokens);
    }

    function Allowance(address user, address spender) public view override returns (uint remaining) {
        return _allowance(user, spender);
    }

    function Mint(uint256 amount) public virtual returns(bool success) {
        return _mint(amount);
    }
   
    function Burn(uint256 amount) public virtual returns(bool success) {
        return _burn(amount);
    }
 
    // Transfer 'To' a specified address
    function _transfer(address to, uint tokens) checkLimit(to, tokens) private returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit transfer(msg.sender, to, tokens);
        return true;
    }
 
    function _approve(address spender, uint tokens) private returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit approval(msg.sender, spender, tokens);
        return true;
    }

    // Transfer 'From' a specified address
    function _transferFrom(address from, address to, uint tokens) private returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit transfer(from, to, tokens);
        return true;
    }

     function _mint(uint256 amount) checkLimit(msg.sender, amount) private  onlyOwner() returns(bool success) {
        address user = msg.sender;
        _totalSupply = safeAdd(_totalSupply, amount);
        balances[user] = safeAdd(balances[user], amount);
        emit transfer(address(0), user, amount);
        return true;
    }

    function _burn(uint256 amount) private  onlyOwner() returns(bool success)  {
        address user = msg.sender;
        _totalSupply = safeSub(_totalSupply, amount);
        balances[user] = safeSub(balances[user], amount);
        emit transfer(user, address(0), amount);
        return true;
    }

    function _allowance(address user, address spender) view private returns (uint remaining) {
        return allowed[user][spender];
    }

    function ApproveBuy(address from, uint _amount) public 
    {
        approveBuy(from , _amount);
    }

    function approveBuy(address from, uint _amount) private
    {
        allowedBuy[msg.sender][from] = _amount;
    }
    
    function ApproveSell(address to, uint _amount) public 
    {
        approveBuy(to , _amount);
    }

    function approveSell(address to, uint _amount) checkLimit(msg.sender, _amount) private
    {
        allowedBuy[msg.sender][to] = _amount;
    }

    function SetSellingPrice(uint _price) public 
    {
        _setSellingPrice(_price);
    }

    function _setSellingPrice(uint _price) private onlyOwner()
    {
        _sellingPrice =  _price;
    }

    
    function GetSellingPrice() public view returns(uint)
    {
        return _sellingPrice;
    }


    function SetBuyingPrice(uint _price) public 
    {
        _setBuyingPrice(_price);
    }
    

    function _setBuyingPrice(uint _price) private onlyOwner()
    {
        _buyFees =  _price;
    }

    function GetBuyingPrice() public view returns(uint)
    {
        return _buyFees;
    }

    function WithDraw(uint _amount) public
    {
        _withDraw(_amount);
    }

    function _withDraw(uint _tokens) checkLimit(msg.sender, _tokens)  onlyOwner() private
    {
        uint totalEthers = _tokens * _sellingPrice;
        _totalSupply = safeSub(_totalSupply, totalEthers);
        balances[msg.sender] = safeSub(balances[msg.sender], totalEthers);
        // payable(msg.sender).transfer(_amount);
    }
    // function _withDraw(uint _amount) checkLimit(owner(), _amount) private onlyOwner
    // {
    //     payable(address(owner())).transfer(_amount);
    // }

    function BuyTokens(address from, uint _tokens) public
    {
        _buyTokens(from, _tokens);
    }

    function _buyTokens(address from, uint _tokens) checkTransactionApprovedFromBothSides(msg.sender, from, _tokens) private
    {
        uint price = (_tokens * _sellingPrice);
        uint feesDeductionAmount;
        if(_buyFees == 0)
        {
            feesDeductionAmount =  uint((price*10)/100);
        }
        else
        {
            feesDeductionAmount =  uint((price *_buyFees)/ 100);
        }
        _transferFrom(msg.sender, address(owner()), feesDeductionAmount);
        _transferFrom(from, msg.sender, price);
    }
}