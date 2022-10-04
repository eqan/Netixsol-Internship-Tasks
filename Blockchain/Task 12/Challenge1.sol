// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Temp{
    struct Person
    {
        string name;
        uint age;
    }
    mapping(uint => Person) users;
    modifier checkAge(uint age)
    {
        require(age > 0 && age < 150);
        _;
    }
    function setUsers(uint _userId, string memory _name, uint _age) public checkAge(_age)
    {
       users[_userId] = Person(_name, _age);
    }
    function getUser(uint _userId) public view returns(Person memory)
    {
        return users[_userId];
    }
}