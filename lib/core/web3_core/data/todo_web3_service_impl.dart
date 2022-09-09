import 'dart:developer';

import 'package:block_todos/core/models/todo_model.dart';
import 'package:block_todos/core/web3_core/data/web3_service.dart';
import 'package:block_todos/core/web3_core/interfaces/todo_web3_interface.dart';

import 'package:rxdart/rxdart.dart';
import 'package:web3dart/web3dart.dart';

class TodoWeb3ServiceImpl extends TodoWeb3Interface {
  final Web3Service _web3service;
  TodoWeb3ServiceImpl({required Web3Service web3service})
      : _web3service = web3service;

  DeployedContract? _deployedContract;
  ContractFunction? _createTaskFunction;
  ContractFunction? _deleteTaskFunction;
  ContractFunction? _updateTaskFunction;
  ContractFunction? _getAllTasksFunction;
  final _streamController = BehaviorSubject<List<Todo>>.seeded(const []);

  @override
  Future<void> createTask({
    required String title,
    required bool isCompleted,
    required int id,
  }) async {
    try {
      await _web3service.web3client?.sendTransaction(
        _web3service.credentials!,
        Transaction.callContract(
          contract: _deployedContract!,
          function: _createTaskFunction!,
          parameters: [id, title, isCompleted],
        ),
      );
    } catch (e) {
      //
      log("$e");
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    try {
      await _web3service.web3client?.call(
        contract: _deployedContract!,
        function: _deleteTaskFunction!,
        params: [id],
      );
    } catch (e) {
      //
      log("$e");
      rethrow;
    }
  }

  @override
  Future<void> getTask() async {
    try {
      //
      var response = await _web3service.web3client?.call(
        contract: _deployedContract!,
        function: _getAllTasksFunction!,
        params: [],
      );
      if (response != null) {
        BigInt totalTasks = response[0];
        for (var i = 0; i < totalTasks.toInt(); i++) {
          //
          print(response[i]);
        }
      }
    } catch (e) {
      //
      log("$e");
      rethrow;
    }
  }

  @override
  Stream<List<Todo>> get todoList => _streamController.asBroadcastStream();

  @override
  Future<void> updateTask({required int id, required bool status}) async {
    try {
      await _web3service.web3client?.sendTransaction(
        _web3service.credentials!,
        Transaction.callContract(
          contract: _deployedContract!,
          function: _updateTaskFunction!,
          parameters: [id, status],
        ),
      );
    } catch (e) {
      //
      log("$e");
      rethrow;
    }
  }

  @override
  Future<void> getDeployedContract() async {
    try {
      _deployedContract = DeployedContract(
        ContractAbi.fromJson(_web3service.abiCode!, "BlockTodos"),
        _web3service.ethereumAddress!,
      );
      _createTaskFunction = _deployedContract?.function("createTask");
      _deleteTaskFunction = _deployedContract?.function("deleteTask");
      _updateTaskFunction = _deployedContract?.function("updateTask");
      _getAllTasksFunction = _deployedContract?.function("getTasks");
    } catch (e) {
      //
    }
  }

  @override
  ContractFunction? get createTaskFunction => _createTaskFunction;

  @override
  ContractFunction? get deleteTaskFunction => _deleteTaskFunction;

  @override
  ContractFunction? get getAllTasksFunction => _getAllTasksFunction;

  @override
  ContractFunction? get updateTaskFunction => _updateTaskFunction;
}
