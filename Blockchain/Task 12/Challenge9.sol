// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/*
    For this challenge, create a smart contract to generate the hash of a pair of
    addresses.
    Here the catch is, the user can enter any of the two addresses as first parameter,but
    the hash generated should be the same.
    To generate hash, two methods are used namely, sha256 and keccak256.
    You can get an overview here.
*/

contract HashPairGenerator
{
    function hashPairGeneration(address a, address b) public pure returns(bytes32 result)
    {
        if(a > b) 
            return keccak256(abi.encodePacked(a , b));
        else 
            return keccak256(abi.encodePacked(b , a));
    }    
}