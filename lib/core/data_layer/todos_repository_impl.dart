import 'dart:convert';

import 'package:block_todos/core/core_constants.dart';
import 'package:block_todos/core/data_layer/data_layer_mixins/todos_repo_imple_mixin.dart';
import 'package:block_todos/core/errors/failure.dart';
import 'package:block_todos/core/models/task_model.dart';
import 'package:block_todos/core/repositories/todos_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodosRepositoryImple extends TodosRepository {
  //================= Variables =================
  Web3Client? _web3client;
  final List<Task> _todosList = [];
  final _streamController = BehaviorSubject<List<Task>>.seeded(const []);
  late Credentials _credentials;
  String _address = '';

  EthereumAddress? _contractAddress;
  EthereumAddress? _ownAddress;
  DeployedContract? _contract;
  ContractFunction? _taskCount;
  ContractFunction? _todos;
  ContractFunction? _createTask;
  ContractEvent? _taskCreatedEvent;
  late String _abiCode;

  ///
  @override
  Future<void> initiateSetUp() async {
    try {
      _web3client =
          Web3Client(CoreConstants.rpcURL, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(CoreConstants.wsURL).cast<String>();
      });
      await getAbi();
      await getCredentials();
      await _getDeployedContarct();
    } on Failure {
      rethrow;
    }
  }

  Future<void> getAbi() async {
    String abiFileString =
        await rootBundle.loadString('src/abis/BlockTodos.json');
    final decoded = jsonDecode(abiFileString) as Map<String, dynamic>;
    _abiCode = jsonEncode(decoded['abi']);
    final hex = decoded['networks']['5777']['address'];
    _address = hex;
    _contractAddress = EthereumAddress.fromHex(hex);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_address);
    _ownAddress = await _credentials.extractAddress();
  }

  Future<void> _getDeployedContarct() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "BlockTodos"), _contractAddress!);
    _taskCount = _contract?.function('taskCount');
    _createTask = _contract?.function('createTask');
    _todos = _contract?.function('todos');
    _taskCreatedEvent = _contract?.event('TaskCreated');
    _getTodos();
  }

  _getTodos() async {
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
          final prevTodos = [..._streamController.value];
          Task task = Task(taskName: temp[0], isCompleted: temp[1]);
          print(temp);
          prevTodos.add(task);
          _todosList.add(task);
          _streamController.add(prevTodos);
        }
      }
    }
    _todosList.clear();
  }

  @override
  Stream<List<Task>> get streamTodoList =>
      _streamController.stream.asBroadcastStream();

  @override
  List<Task> get taskList => _todosList;

  @override
  Future<void> createTask(String task, [bool isCompleted = false]) async {
    try {
      //
      await _web3client?.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract!,
          function: _createTask!,
          parameters: [task],
        ),
      );
      _getTodos();
    } catch (e) {
      print("Error Creating :  $e");
      // throw Exception();
    }
  }
}

final todosRepositoryImple =
    Provider<TodosRepository>((ref) => TodosRepositoryImple());
