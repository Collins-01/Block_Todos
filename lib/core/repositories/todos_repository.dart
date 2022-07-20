import 'package:block_todos/core/models/task_model.dart';

abstract class TodosRepository {
  Stream<List<Task>> get streamTodoList;
  List<Task> get taskList;
  Future<void> createTask(String task, [bool isCompleted = false]);
  Future<void> initiateSetUp();
}
