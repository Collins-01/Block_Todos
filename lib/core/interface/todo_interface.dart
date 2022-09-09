import 'package:block_todos/core/models/task_model.dart';
import 'package:block_todos/core/models/todo_model.dart';

abstract class TodosInterface {
  const TodosInterface();

  /// Returns  the list of Tasks as a Stream List
  Stream<List<Todo>> get streamTodoList;

  /// Returns the List of Tasks
  List<Todo> get taskList;

  /// Create a Task on the Blockchain takes in [taskName: String]
  Future<void> createTask(String task, [bool isCompleted = false]);

  /// Method Called to Create a connection to the blockchain
  Future<void> initiateSetUp();

  /// Changes the State of a Particular task, takes in [index: int] and [isCompleted: bool]
  Future<void> toggleTodo(int index, bool isComplete);

  /// Function To get all the Tasks from teh Blockchain
  Future<void> getAllTasks();
}
