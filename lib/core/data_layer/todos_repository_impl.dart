import 'dart:async';

import 'package:block_todos/core/core_constants.dart';
import 'package:block_todos/core/data_layer/data_layer_mixins/todos_repo_imple_mixin.dart';
import 'package:block_todos/core/errors/failure.dart';
import 'package:block_todos/core/models/task_model.dart';
import 'package:block_todos/core/repositories/todos_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodosRepositoryImple extends TodosRepository
    with ChangeNotifier, TodosRepositoryImpleMixin {
  //================= Variables =================
  Web3Client? _web3client;
  final List<Task> _todosList = [];
  final _streamController = StreamController<List<Task>>.broadcast();
  late Credentials _credentials;
  final String _address = '';

  bool get _socketExists => _web3client != null;
  @override
  bool get socketExists => _socketExists;

  EthereumAddress? _contractAddress;
  EthereumAddress? _ownAddress;
  DeployedContract? _contract;
  ContractFunction? _taskCount;
  ContractFunction? _todos;
  ContractFunction? _createTask;
  ContractEvent? _taskCreatedEvent;
  late String _abiCode;

  // ===================Methods=============
  Future<void> initiateSetUp() async {
    try {
      _web3client =
          Web3Client(CoreConstants.rpcURL, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(CoreConstants.wsURL).cast<String>();
      });
      await getAbi(
        abiCode: _abiCode,
        address: _address,
        contractAddress: _contractAddress,
      );
      await getCredentials(
        address: _address,
        credentials: _credentials,
        ownAddress: _ownAddress,
      );
      await getDeployedContarct();
    } on Failure {
      rethrow;
    }
  }

  Future<void> getDeployedContarct() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "BlockTodos"), _contractAddress!);
    _taskCount = _contract?.function('taskCount');
    _createTask = _contract?.function('createTask');
    _todos = _contract?.function('todos');
    _taskCreatedEvent = _contract?.event('TaskCreated');
    // _todos
    getTodos();
  }

  getTodos() async {
    var totalTaskList = await _web3client
        ?.call(contract: _contract!, function: _taskCount!, params: []);
    if (totalTaskList != null) {
      BigInt totalTasks = totalTaskList[0];
      for (var i = 0; i < totalTasks.toInt(); i++) {
        var temp = await _web3client?.call(
          contract: _contract!,
          function: _todos!,
          params: [
            BigInt.from(i),
          ],
        );
        if (temp != null) {
          Task task = Task(taskName: temp[0], isCompleted: temp[1]);
          _todosList.add(task);
          notifyListeners();
          print(_todosList[0].taskName);
        }
      }
    }
    _todosList.clear();
  }

  @override
  Stream<List<Task>> get streamTodoList => _streamController.stream;

  @override
  List<Task> get taskList => _todosList;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

final todosRepositoryImple = Provider((ref) => TodosRepositoryImple());
