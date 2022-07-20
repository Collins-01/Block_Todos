import 'package:block_todos/core/core_constants.dart';
import 'package:block_todos/core/data_layer/data_layer_mixins/todos_repo_imple_mixin.dart';
import 'package:block_todos/core/models/task_model.dart';
import 'package:block_todos/core/repositories/todos_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodosRepositoryImple extends ChangeNotifier
    with TodosRepositoryImpleMixin {
  TodosRepositoryImple() {
    print("dbcdcjdb");
    initiateSetUp();
  }
  List<Task> _todos = [];
  Web3Client? _web3client;

  bool get _socketExists => _web3client != null;
  // @override
  bool get socketExists => _socketExists;
  //* Initiates SetUp
  Future<void> initiateSetUp() async {
    print("Initiates setup");
    _web3client =
        Web3Client(CoreConstants.rpcURL, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(CoreConstants.wsURL).cast<String>();
    });
    getAbi();
  }
}

final todosRepositoryImple =
    ChangeNotifierProvider((ref) => TodosRepositoryImple());
