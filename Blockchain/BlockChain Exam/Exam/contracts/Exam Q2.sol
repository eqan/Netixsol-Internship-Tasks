/*
    Make an ERC721 contract. It will have a change able max supply. The owner of contract will be able to change the max supply anytime. 
    Each owner of nft can change the data uri of his nft only once. Means that if the owner of nft will change the new owner will have one chance to change the data uri of his nft. 
    Also confirm that opensea should be able to list you nfts. And each time data uri changes nft on opensea should be changing as well. 
    Write proper tests for every function. 
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract SafeMath {

    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
 
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
 
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
 
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
 
abstract contract ERC721Interface
{
    // Enables or disables an operator to manage all of msg.sender's assets
    function setApprovalForAll(address _operator, bool _approved) public virtual;
    // Checks if an address is an operator for another address
    function isApprovedForAll(address _owner, address _operator) public virtual view returns (bool);
    // Updates an approved address for an NFT
    function approve(address _to, uint256 _tokenId) public virtual;
    // Finds the owner of an NFT
    function ownerOf(uint256 _tokenId) public virtual view returns (address);
    // Gets the approved address for a single NFT
    function getApproved(uint256 _tokenId) public virtual view returns (address);
    // Transfers ownership of an NFT
    function transferFrom(address _from, address _to, uint256 _tokenId) public virtual;
    // Check if onERC721Received is implemented WHEN sending to smart contracts
    function safeTransferFrom( address _from, address _to, uint256 _tokenId, bytes memory _data ) public virtual;
    event ApprovalForAll( address indexed _owner, address indexed _operator, bool _approved);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

}

contract ExamQ2 is ERC721Interface, SafeMath, Ownable
{

    string public name;
    string public symbol;
    uint private totalSupplyCapacity;

    struct MetaData
    {
        string dataURI;
        bool isChanged;
    }

    // NFT URI
    mapping(address => mapping(uint256 => MetaData)) internal dataURIs; // Owner => NFT => URI
    // Number of NFTs assigned to an owner
    mapping(address => uint256) internal balances; // Owners => Balances
    // Find owners of an NFT
    mapping(uint256 => address) internal owners; // TokenID => Token Address
    // Enables or disables an operator to manage all of msg.sender's assets
    mapping(address => mapping(address => bool)) private operatorApprovals; // NFT owner => operator => approved or not
    // Gets the approved address for a single NFT
    mapping(uint256 => address) private tokenApprovals; // token ID => approved address

    modifier checkTokenSupply(address user, uint _amount)
    {
        require(balances[user] + _amount <=  totalSupplyCapacity, "Supply has reached its limit");
        _;
    }

    modifier checkIfTokenIdExists(uint256 _tokenId) {
        require(owners[_tokenId] == address(0), "TokenId does already exists");
        _;
    }

    modifier checkIfTokenIdDoesntExist(uint256 _tokenId) {
        require(owners[_tokenId] != address(0), "TokenId doesnt exists");
        _;
    }


    modifier checkOwner(address _owner)
    {
        require(_owner != address(0), "Address is zero");
        _;
    }

    modifier checkURIChanged(address _owner, uint _tokenID)
    {
        require(dataURIs[_owner][_tokenID].isChanged == false, "URI has been changed once");
        _;
    }

    constructor(string memory _name,string memory _symbol, uint _totalSupplyCapacity){
        name=_name;
        symbol=_symbol;
        totalSupplyCapacity = _totalSupplyCapacity;
    }

    function getMaxSupply() public view returns(uint)
    {
        return totalSupplyCapacity;
    }
    // Returns the number of NFTs assigned to an owner
    function balanceOf(address _owner) public view checkOwner(_owner) returns (uint256) 
    {
        return balances[_owner];
    }

    // Finds the owner of an NFT
    function ownerOf(uint256 _tokenId) public override view checkIfTokenIdDoesntExist(_tokenId) returns (address)
    {
        return owners[_tokenId];
    }

    // OPERATOR
    // Enables or disables an operator to manage all of msg.sender's assets
    function setApprovalForAll(address _operator, bool _approved) public override
    {
        operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    // Checks if an address is an operator for another address
    function isApprovedForAll(address _owner, address _operator) public override view returns (bool)
    {
        return operatorApprovals[_owner][_operator];
    }

    // APPROVAL
    // Updates an approved address for an NFT
    function approve(address _to, uint256 _tokenId) public override {
        address owner = ownerOf(_tokenId);
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "Msg.sender is not the owner or an approved operator"
        );
        tokenApprovals[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }

    // Gets the approved address for a single NFT
    function getApproved(uint256 _tokenId) public override view checkIfTokenIdDoesntExist(_tokenId) returns (address)
    {
        return tokenApprovals[_tokenId];
    }

    // TRANSFER
    // Before the transferFrom function is called, the NFT owner must first approve that msg. 
    // Transfers ownership of an NFT
    function transferFrom(address _from, address _to, uint256 _tokenId) public override checkIfTokenIdDoesntExist(_tokenId) checkTokenSupply(_to, 1)
    {
        address owner = ownerOf(_tokenId);
        require(
            msg.sender == owner ||
                getApproved(_tokenId) == msg.sender ||
                isApprovedForAll(owner, msg.sender),
            "Msg.sender is not the owner or approved for transfer"
        );
        require(owner == _from, "From address is not the owner");
        require(_to != address(0), "Address is zero");
        approve(address(0), _tokenId);

        balances[_from] = safeSub(balances[_from], 1);
        balances[_to] = safeAdd(balances[_to], 1);
        owners[_tokenId] = _to;
        dataURIs[_to][_tokenId] = MetaData(dataURIs[_from][_tokenId].dataURI, false);
        delete dataURIs[_from][_tokenId];

        emit Transfer(_from, _to, _tokenId);
    }

    // Standard transferFrom
    // Check if onERC721Received is implemented WHEN sending to smart contracts
    function safeTransferFrom( address _from, address _to, uint256 _tokenId, bytes memory _data ) public  override
    {
        transferFrom(_from, _to, _tokenId);
        require(checkOnERC721Received(), "Receiver not implemented");
    }

    function safeTransferFrom( address _from, address _to, uint256 _tokenId) public
    {
        safeTransferFrom(_from, _to, _tokenId, "Data");
    }

    // Oversimplified => what would actually do: call the smart contract's onERC721Received function and check if any response is given
    function checkOnERC721Received() private pure returns (bool)
    {
        return true;
    }

    function Mint(uint256 tokenId, string memory dataURI) public
    {
        _mint(tokenId, dataURI);
    }

    function Burn(uint256 tokenId) public
    {
        _burn(tokenId);
    }

    function _mint(uint256 tokenId, string memory dataURI) internal virtual checkIfTokenIdExists(tokenId) checkTokenSupply(msg.sender, 1)
    {
        address user = msg.sender;
        require(user != address(0), "ERC721: mint to the zero address");

        balances[user] = safeAdd(balances[user],1);
        owners[tokenId] = user;
        dataURIs[user][tokenId].dataURI = dataURI;
        dataURIs[user][tokenId].isChanged = false;

        emit Transfer(address(0), user, tokenId);
    }


    function _burn(uint256 tokenId) internal virtual {
        address owner = ownerOf(tokenId);

        // Clear approvals
        approve(address(0), tokenId);

        balances[owner] = safeSub(balances[owner], 1);
        delete owners[tokenId];
        delete dataURIs[owner][tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    function GetNFTDataURI(uint _tokenID) public view returns(string memory)
    {
        return getNFTDataURI(_tokenID);
    }

    function getNFTDataURI(uint _tokenID) private view checkIfTokenIdDoesntExist(_tokenID) returns(string memory)
    {
        return dataURIs[msg.sender][_tokenID].dataURI;
    }

    function SetMaxTokenSupply(uint _newMaxtotalSupplyCapacityCapacity) public
    {
        setMaxTokenSupply(_newMaxtotalSupplyCapacityCapacity);
    }

    function GetMaxTokenSupply() public
    {
        return totalSupplyCapacity;
    }

    function setmaxtokensupply(uint _newmaxtotalsupplycapacitycapacity) private onlyowner()
    {
        totalSupplyCapacity =  _newMaxtotalSupplyCapacityCapacity;
    }

    function SetNFTDataURI(uint _tokenID, string memory _dataURI) public
    {
        setNFTDataURI(_tokenID, _dataURI);
    }

    function setNFTDataURI(uint _tokenID, string memory _dataURI) private checkIfTokenIdDoesntExist(_tokenID) checkURIChanged(msg.sender, _tokenID)
    {
        dataURIs[msg.sender][_tokenID].dataURI = _dataURI;
        dataURIs[msg.sender][_tokenID].isChanged = true;
    }
}