import 'package:block_todos/core/models/models.dart';
import 'package:web3dart/web3dart.dart';

abstract class TodoWeb3Interface {
//Get Deployed Contract
//Get Contract Functions

  Future<void> getDeployedContract();
  ContractFunction? get createTaskFunction;
  ContractFunction? get deleteTaskFunction;
  ContractFunction? get updateTaskFunction;
  ContractFunction? get getAllTasksFunction;

  //CRUD

  Future<void> createTask(
      {required String title, required bool isCompleted, required int id});

  Future<void> updateTask({required int id, required bool status});

  Future<void> deleteTask(int id);
  Future<void> getTask();
  Stream<List<Todo>> get todoList;
}

abstract class TodoWeb3Repository extends TodoWeb3Interface {}

abstract class TodoWeb3Service extends TodoWeb3Interface {}
