import 'package:block_todos/core/data/todos_service.dart';
import 'package:block_todos/core/domain/todos_repository.dart';
import 'package:block_todos/core/web3_core/web3_core.dart';
import 'package:block_todos/presentation/splash/splash_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) {
        // final web3Service = Web3Service();
        return TodosRepository(
          todosService: TodosService(
            web3service: Web3Service(),
            todoWeb3ServiceImpl: TodoWeb3ServiceImpl(
              web3service: Web3Service(),
            ),
          ),
        );
      },
      child: MaterialApp(
        title: 'Block Todos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreenPage(),
      ),
    );
  }
}
