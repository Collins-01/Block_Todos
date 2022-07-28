import 'package:block_todos/core/data_layer/data_layer.dart';
import 'package:block_todos/core/interface/todo_interface.dart';
import 'package:block_todos/core/models/task_model.dart';

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
  Stream<List<Task>> get streamTodoList => _todosService.streamTodoList;

  @override
  List<Task> get taskList => _todosService.taskList;

  @override
  Future<void> toggleTodo(int index, bool isComplete) async {
    await _todosService.toggleTodo(index, isComplete);
  }
}
