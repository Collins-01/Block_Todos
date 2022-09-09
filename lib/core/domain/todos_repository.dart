import 'package:block_todos/core/interface/todo_interface.dart';
import 'package:block_todos/core/models/task_model.dart';
import 'package:block_todos/core/models/todo_model.dart';

import '../data/todos_service.dart';

class TodosRepository extends TodosInterface {
  final TodosService _todosService;
  TodosRepository({required TodosService todosService})
      : _todosService = todosService;
  @override
  Future<void> createTask(String task, [bool isCompleted = false]) async {
    await _todosService.createTask(task);
  }

  @override
  Future<void> getAllTasks() async {
    await _todosService.getAllTasks();
  }

  @override
  Future<void> initiateSetUp() async {
    await _todosService.initiateSetUp();
  }

  @override
  Stream<List<Todo>> get streamTodoList => _todosService.streamTodoList;

  @override
  List<Todo> get taskList => _todosService.taskList;

  @override
  Future<void> toggleTodo(int index, bool isComplete) async {
    await _todosService.toggleTodo(index, isComplete);
  }
}
