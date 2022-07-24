import 'package:block_todos/core/data_layer/todos_repository_impl.dart';
import 'package:block_todos/core/locator.dart';
import 'package:block_todos/presentation/create_todos/create_todos_view.dart';
import 'package:block_todos/presentation/splash/bloc/bloc.dart';
import 'package:block_todos/presentation/splash/bloc/splash_screen_bloc.dart';
import 'package:block_todos/presentation/splash/bloc/splash_screen_events.dart';
import 'package:block_todos/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _todoRepositoryInstance = locator<TodosRepositoryImple>();

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashScreenBloc(
        todosRepositoryImple: _todoRepositoryInstance,
      ),
      child: const _SplashScreenView(),
    );
  }
}

class _SplashScreenView extends StatefulWidget {
  const _SplashScreenView({Key? key}) : super(key: key);

  @override
  State<_SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<_SplashScreenView> {
  @override
  void initState() {
    super.initState();
    // final _splashScreenBloc =
    //     SplashScreenBloc(todosRepositoryImple: TodosRepositoryImple());

    _init();
  }

  _init() async {
    try {
      Future.delayed(const Duration(milliseconds: 100));
      await _todoRepositoryInstance.initiateSetUp().then((value) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const CreateTodoPage()));
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<SplashScreenBloc, SplashScreenState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == SplashScreenStatus.isSuccess,
      listener: (context, state) {
        // print(state.status);
      },
      bloc: SplashScreenBloc(
        todosRepositoryImple: _todoRepositoryInstance,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Center(child: Text("BLOCK 🧊 - TODOS 🖋 ")),
            const Spacer(),
            BlocBuilder<SplashScreenBloc, SplashScreenState>(
              bloc: SplashScreenBloc(
                todosRepositoryImple: _todoRepositoryInstance,
              ),
              builder: (context, state) {
                if (state.status.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    ));
  }
}
/*
error.
  ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );

navigate
 Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const CreateTodoPage(),
              ),
            );

/
 SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Center(child: Text("BLOCK 🧊 - TODOS 🖋 ")),
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
            ),
          );
*/