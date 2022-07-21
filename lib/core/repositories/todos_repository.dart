import 'package:block_todos/core/models/task_model.dart';

abstract class TodosRepository {
  /// Returns  the list of Tasks as a Stream List
  Stream<List<Task>> get streamTodoList;

  /// Returns the List of Tasks
  List<Task> get taskList;

  /// Create a Task on the Blockchain takes in [taskName: String]
  Future<void> createTask(String task, [bool isCompleted = false]);

  /// Method Called to Create a connection to the blockchain
  Future<void> initiateSetUp();

  /// Changes the State of a Particular task, takes in [index: int] and [isCompleted: bool]
  Future<void> toggleTodo(int index, bool isComplete);
}
