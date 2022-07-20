import 'package:block_todos/core/models/task_model.dart';

abstract class TodosRepository {
  bool get socketExists;
  Stream<List<Task>> get streamTodoList;
  List<Task> get taskList;
}
