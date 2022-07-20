import 'dart:convert';
import 'dart:developer';

import 'package:block_todos/core/core_constants.dart';
import 'package:block_todos/core/models/task_model.dart';
// import 'package:block_todos/core/data_layer/data_layer_mixins/todos_repo_imple_mixin.dart';
// import 'package:block_todos/core/models/task_model.dart';
// import 'package:block_todos/core/repositories/todos_repository.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodosRepositoryImple {
  /// Constructor
  // TodosRepositoryImple() {
  //   print("Constructore Callled");
  //   initiateSetUp();
  // }
  List<Task> _todosList = [];
  List<Task> get todosList => _todosList;
  //================= Variables =================
  Web3Client? _web3client;
  late Credentials _credentials;
  String _address = '';

  bool get _socketExists => _web3client != null;
  // @override
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
    _web3client =
        Web3Client(CoreConstants.rpcURL, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(CoreConstants.wsURL).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContarct();
  }

  Future<void> getAbi() async {
    String abiFileString =
        await rootBundle.loadString('src/abis/BlockTodos.json');
    final decoded = jsonDecode(abiFileString) as Map<String, dynamic>;
    _abiCode = jsonEncode(decoded['abi']);
    final hex = decoded['networks']['5777']['address'];
    _address = hex;
    _contractAddress = EthereumAddress.fromHex(hex);
    print(_contractAddress);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_address);
    _ownAddress = await _credentials.extractAddress();
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
        print(temp);
      }
    }
    _todosList.clear();
  }
}

final todosRepositoryImple = Provider((ref) => TodosRepositoryImple());
