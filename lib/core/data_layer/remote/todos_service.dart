import 'dart:convert';
import 'dart:developer';
import 'package:block_todos/core/core_constants.dart';
import 'package:block_todos/core/interface/todo_interface.dart';
import 'package:block_todos/core/models/task_model.dart';
import 'package:block_todos/utils/app_logger.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodosService extends TodosInterface {
  //================= Variables =================
  Web3Client? _web3client;
  final List<Task> _todosList = [];
  final _streamController = BehaviorSubject<List<Task>>.seeded(const []);
  late Credentials _credentials;
  String _address = '';

  EthereumAddress? _contractAddress;
  // ignore: unused_field
  EthereumAddress? _ownAddress;
  DeployedContract? _contract;
  ContractFunction? _taskCount;
  ContractFunction? _todos;
  ContractFunction? _createTask;
  // ignore: unused_field
  ContractEvent? _taskCreatedEvent;
  late String _abiCode;

  ///
  @override
  Future<void> initiateSetUp() async {
    try {
      //* Connect to the ETH Network
      _web3client =
          Web3Client(CoreConstants.rpcURL, Client(), socketConnector: () {
        return IOWebSocketChannel.connect(CoreConstants.wsURL).cast<String>();
      });
      //* Get ABIs
      await _getAbi();
      await _getCredentials();
      await _getDeployedContarct();
    } catch (e) {
      rethrow;
      // print("Error Initialising :::: $e");
      // rethrow;
    }
  }

  Future<void> _getAbi() async {
    String abiFileString =
        await rootBundle.loadString('src/abis/BlockTodos.json');
    final decoded = jsonDecode(abiFileString) as Map<String, dynamic>;
    _abiCode = jsonEncode(decoded['abi']);
    final hex = decoded['networks']['5777']['address'];
    _address = hex;
    _contractAddress = EthereumAddress.fromHex(hex);
    // print(_address);
  }

  Future<void> _getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_address);
    _ownAddress = await _credentials.extractAddress();
    // print(_ownAddress?.hex);
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

  /// Fetches the List of Tasks from the Blockchain
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
            /// we communicate with e blockchain with BigInts, becuase we specify our data types as [uint256]
            BigInt.from(i),
          ],
        );
        if (temp != null) {
          List<Task> prevTodos = [];
          Task task = Task(taskName: temp[0], isCompleted: temp[1]);
          prevTodos.add(task);
          _streamController.add(prevTodos);
          _todosList.add(task);
          print("Tasks from Contract: ${_streamController.value}");
        }
      }
    }
  }

  @override
  Stream<List<Task>> get streamTodoList =>
      _streamController.asBroadcastStream();

  @override
  List<Task> get taskList => _todosList;

  @override
  Future<void> createTask(String task, [bool isCompleted = false]) async {
    try {
      //
      // final list = [..._streamController.value];
      // final item = Task(taskName: task, isCompleted: isCompleted);
      // // list.add(item);
      // _streamController.add(list);
      await _web3client?.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract!,
          function: _createTask!,
          parameters: [task],
        ),
      );
    } catch (e) {
      log(e.toString());
      rethrow;
      // print("Error Creating :  $e");
      // throw Exception();
    }
  }

  @override
  Future<void> toggleTodo(int index, bool isComplete) async {
    try {
      final list = [..._streamController.value];
      final item = list[index];
      final edited = Task(taskName: item.taskName, isCompleted: isComplete);
      list.removeAt(index);
      list.insert(index, edited);
      _streamController.add(list);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<void> getAllTasks() async {
    var totalTaskList = await _web3client
        ?.call(contract: _contract!, function: _taskCount!, params: []);
    if (totalTaskList != null) {
      BigInt totalTasks = totalTaskList[0];
      for (var i = 0; i < totalTasks.toInt(); i++) {
        var temp = await _web3client?.call(
          contract: _contract!,
          function: _todos!,
          params: [
            /// we communicate with e blockchain with BigInts, becuase we specify our data types as [uint256]
            BigInt.from(i),
          ],
        );
        if (temp != null) {
          List<Task> prevTodos = [];
          Task task = Task(taskName: temp[0], isCompleted: temp[1]);
          prevTodos.add(task);
          _streamController.add(prevTodos);
          _todosList.add(task);
          AppLogger.log(prevTodos);
          AppLogger.log(_streamController.value);
        }
      }
    }
  }
}
