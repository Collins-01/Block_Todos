import 'dart:developer';

import 'package:block_todos/presentation/create_todos/create_todos_view.dart';
import 'package:block_todos/presentation/splash/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/domain_layer/repositories/repositories.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashScreenBloc(
        todosRepositoryImple: context.read<TodosRepository>(),
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
    context.read<SplashScreenBloc>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<SplashScreenBloc>().init();
        },
      ),
      body: BlocConsumer<SplashScreenBloc, SplashScreenState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Center(child: Text("BLOCK 🧊 - TODOS 🖋 ")),
                const Spacer(),
                Text(state.status.name),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          );
        },
        listener: (context, state) {
          log("Status : ${state.status.name}");
          if (state.status.isError) {
            //show snack bar
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
          }
          if (state.status.isSuccess) {
            //navigate
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const CreateTodoPage(),
              ),
            );
          }
          // if (state.status.isLoading) {
          //   //navigate
          //   Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(
          //       builder: (_) => const CreateTodoPage(),
          //     ),
          //   );
          // }
          // if (state.status.idle) {
          //   //navigate
          //   Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(
          //       builder: (_) => const CreateTodoPage(),
          //     ),
          //   );
          // }
        },
        listenWhen: (prev, curr) => prev.status != curr.status,
      ),
    );
  }
}
/*
 BlocListener<SplashScreenBloc, SplashScreenState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == SplashScreenStatus.isSuccess,
        listener: (context, state) {
          if (state.status.isSuccess) {
            //navigate
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const CreateTodoPage(),
              ),
            );
          }
          if (state.status.isError) {
            //show snack bar
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
          }
        },
        bloc: SplashScreenBloc(
          todosRepositoryImple: context.read<TodosRepositoryImple>(),
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
                  todosRepositoryImple: context.read<TodosRepositoryImple>(),
                ),
                builder: (context, state) {
                  if (state.status.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  if (state.status.isError) {
                    return const Center(
                      child: Text("An Error Occured"),
                    );
                  }

                  return Text(state.status.name);
                },
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
*/