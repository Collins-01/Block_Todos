import 'package:block_todos/core/interface/todo_interface.dart';
import 'package:block_todos/core/models/task_model.dart';
import 'package:block_todos/core/models/todo_model.dart';
import 'package:block_todos/core/web3_core/web3_core.dart';

class TodosService extends TodosInterface {
  final Web3Service _web3service;
  final TodoWeb3ServiceImpl _todoWeb3ServiceImpl;
  TodosService(
      {required Web3Service web3service,
      required TodoWeb3ServiceImpl todoWeb3ServiceImpl})
      : _web3service = web3service,
        _todoWeb3ServiceImpl = todoWeb3ServiceImpl;
  @override
  Future<void> createTask(String task, [bool isCompleted = false]) async {}

  @override
  Future<void> getAllTasks() async {
    throw UnimplementedError();
  }

  @override
  Future<void> initiateSetUp() async {
    try {
      await _web3service.initialise().then((value) async {
        await _web3service.getAbi();
        await _web3service.getCredentials();
      });
    } catch (e) {}
  }

  @override
  Stream<List<Todo>> get streamTodoList => _todoWeb3ServiceImpl.todoList;

  @override
  List<Todo> get taskList => [];

  @override
  Future<void> toggleTodo(int index, bool isComplete) {
    throw UnimplementedError();
  }
  //================= Variables =================

}
