import 'package:block_todos/core/data_layer/todos_repository_impl.dart';
import 'package:block_todos/presentation/create_todos/create_todos_view.dart';
import 'package:block_todos/presentation/splash/bloc/bloc.dart';
import 'package:block_todos/presentation/splash/bloc/splash_screen_bloc.dart';
import 'package:block_todos/presentation/splash/bloc/splash_screen_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashScreenBloc(
        todosRepositoryImple: context.read<TodosRepositoryImple>(),
      )..add(
          const InitialiseEvent(),
        ),
      child: const SplashScreenView(),
    );
  }
}

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.,
      body: BlocConsumer<SplashScreenBloc, SplashScreenState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("BLOCK 🧊 - TODOS 🖋 "),
              const Spacer(),
              state.status.isLoading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 30,
              )
            ],
          );
        },
        listener: (context, state) {
          if (state.status.isSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const CreateTodoPage(),
              ),
            );
          }
          if (state.status.isError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
          }
        },
      ),
    );
  }
}
