import 'package:block_todos/core/data_layer/data_layer.dart';
import 'package:block_todos/core/domain_layer/domain_layer.dart';
import 'package:block_todos/presentation/splash/splash_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodosRepository(todosService: TodosService()),
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
