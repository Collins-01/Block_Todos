// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract SolidTodos{ 
    uint public taskCount;
    struct Task { 
        string taskName;
        bool isCompleted;
    }
    mapping(uint => Task) public todos;

    event TaskCreated(string task, uint taskNumber );
    constructor ()  {
        taskCount  = 0 ;
    }

    function createTask(string memory _taskName)  public  {
        //* Add Task to Mapping
        todos[taskCount++] = Task(_taskName, false);
        // * Emit Task Created Event
        emit TaskCreated(_taskName, taskCount -1);
        
    }
} 