// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// In detail explanation of the smart contract
// shorturl.at/bkWZ8

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

contract BTCToken is ERC721Interface, SafeMath 
{

    string public name;
    string public symbol;

    // Number of NFTs assigned to an owner
    mapping(address => uint256) internal balances; // Owners => Balances
    // Find owners of an NFT
    mapping(uint256 => address) internal owners; // TokenID => Token Address
    // Enables or disables an operator to manage all of msg.sender's assets
    mapping(address => mapping(address => bool)) private operatorApprovals; // NFT owner => operator => approved or not
    // Gets the approved address for a single NFT
    mapping(uint256 => address) private tokenApprovals; // token ID => approved address

    constructor(string memory _name,string memory _symbol){
        name=_name;
        symbol=_symbol;
    }
    
    // Returns the number of NFTs assigned to an owner
    function balanceOf(address _owner) public view checkOwner(_owner) returns (uint256) 
    {
        return balances[_owner];
    }

    // Finds the owner of an NFT
    function ownerOf(uint256 _tokenId) public override view tokenIdExists(_tokenId) returns (address)
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
    function getApproved(uint256 _tokenId) public override view tokenIdExists(_tokenId) returns (address)
    {
        return tokenApprovals[_tokenId];
    }

    // TRANSFER
    // Before the transferFrom function is called, the NFT owner must first approve that msg. 
    // Transfers ownership of an NFT
    function transferFrom(address _from, address _to, uint256 _tokenId) public override tokenIdExists(_tokenId)
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

        safeSub(balances[_from], 1);
        safeAdd(balances[_to], 1);
        owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    // Standard transferFrom
    // Check if onERC721Received is implemented WHEN sending to smart contracts
    function safeTransferFrom( address _from, address _to, uint256 _tokenId, bytes memory _data ) public override
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

    function _mint(address to, uint256 tokenId) internal virtual tokenIdExists(tokenId)
    {
        require(to != address(0), "ERC721: mint to the zero address");

        // _beforeTokenTransfer(address(0), to, tokenId);

        safeAdd(balances[to],1);
        owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        // _afterTokenTransfer(address(0), to, tokenId);
    }


    function _burn(uint256 tokenId) internal virtual {
        address owner = ownerOf(tokenId);

        // _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        approve(address(0), tokenId);

        safeSub(balances[owner], 1);
        delete owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        // _afterTokenTransfer(owner, address(0), tokenId);
    }


    modifier tokenIdExists(uint256 _tokenId) {
        require(owners[_tokenId] != address(0), "TokenId does not exist");
        _;
    }

    modifier checkOwner(address _owner)
    {
        require(_owner != address(0), "Address is zero");
        _;
    }
}