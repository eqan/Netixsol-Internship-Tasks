// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ToDoList is Ownable {
    struct Task{
        string taskName;
        string taskDescription;
        uint date;
        bool status;
    }
    mapping(address => Task[]) private tasks;

    constructor () Ownable()
    {

    }

    modifier checkTaskLength(uint taskId)
    {
        require(tasks[msg.sender].length > taskId, "Error: Tasks Input Has OverFlowed The Total Tasks!");
        _;
    }

    function addTask(string memory _taskName, string memory _taskDescription) public
    {
        tasks[msg.sender].push(Task(_taskName, _taskDescription, block.timestamp, false));
    }

    function updateTask(uint taskID, bool _status) public checkTaskLength(taskID)
    {
        tasks[msg.sender][taskID].status = _status;
    }

    function displayList() public view returns(Task[] memory)
    {
        uint validCount=0;
        uint tempArrCount=0;

        for(uint i = 0; i < tasks[msg.sender].length; i++) {
            if(tasks[msg.sender][i].status == true){
                validCount+=1;
            }
        }
        Task [] memory listArr = new Task[](validCount) ;

        for(uint i = 0; i < tasks[msg.sender].length; i++) {
            if(tasks[msg.sender][i].status == false){
                listArr[tempArrCount] = tasks[msg.sender][i];
                tempArrCount+=1;
            }
        }
        return listArr;
    }
}