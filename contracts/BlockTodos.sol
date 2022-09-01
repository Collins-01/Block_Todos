// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract BlockTodos{ 
    ///Public task count variable that holds the total number of tasks on the Blockchain.
    uint public taskCount;
    //Task Object
    struct Task { 
        string taskName;
        bool isCompleted;
        
    }
    /// Like a Map type Variable in [Dart], or a dictionary type variable in [Swift]
    /// or a json type variable in [JavaScript]
    ///the key is a uint256, and the Value is a Task Object.
    ///Values of a mapping data type are accessed like: `todos[key]`
    mapping(uint256 => Task) public todos;
    /// TaskCreated Event will be emitted when a new task is created.
    event TaskCreated(string task, uint256 taskNumber );
    /// TaskToggled even will be emitted when a request for a task to be emitted is sent from the client side.
    /// it takes in the index[key] and  isCompleted[boolean value]
    event TaskToggled(uint256 index, bool completed );
    ///Constructor of our Contract
    constructor ()  {
        //Initialising Task Count to 0.
        taskCount  = 0 ;
        //setting the first task in the dictionary to :::: Task(name, isCompleted )
        todos[0] = Task("Test Task", true);
        ///Task Count is being increased, because it holds the total lenght of tasks on the blockchain.
        taskCount = 1;

    }

    function createTask(string memory _taskName)  public  {
        //* Add Task to Mapping
        todos[taskCount++] = Task(_taskName, false);
        // * Emit Task Created Event
        emit TaskCreated(_taskName, taskCount -1);
        
    }
     function toggleTask( uint256 index , bool  isCompleted) public {
        
        //Check if the index exists in the array
        //if [Y] Edit the Task based on the index, then emit to the Client side.
        // if [N] throw an error


        
        emit TaskToggled(index, isCompleted);
     }
} 