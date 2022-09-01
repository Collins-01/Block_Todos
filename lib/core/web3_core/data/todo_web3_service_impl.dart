import 'package:block_todos/core/models/todo_model.dart';
import 'package:block_todos/core/web3_core/interfaces/interfaces.dart';
import 'package:block_todos/core/web3_core/interfaces/web3_interface.dart';
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
  Future<void> createTask(
      {required String title,
      required bool isCompleted,
      required int id}) async {
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
    }
  }

  @override
  Future<void> deleteTask(int id) {
    throw UnimplementedError();
  }

  @override
  Future<void> getTask() async {
    try {
      //
      var res = await _web3service.web3client?.call(
        contract: _deployedContract!,
        function: _getAllTasksFunction!,
        params: [],
      );
    } catch (e) {
      //
    }
  }

  @override
  Stream<List<Todo>> get todoList => throw UnimplementedError();

  @override
  Future<void> updateTask({required int id, required bool status}) {
    throw UnimplementedError();
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
