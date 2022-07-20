// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract BlockTodos{ 
    uint public taskCount;
    struct Task { 
        string taskName;
        bool isCompleted;
    }
    mapping(uint256 => Task) public todos;

    event TaskCreated(string task, uint256 taskNumber );
    constructor ()  {
        taskCount  = 0 ;
        todos[0] = Task("Test Task", true);
        taskCount = 1;

    }

    function createTask(string memory _taskName)  public  {
        //* Add Task to Mapping
        todos[taskCount++] = Task(_taskName, false);
        // * Emit Task Created Event
        emit TaskCreated(_taskName, taskCount -1);
        
    }
} 