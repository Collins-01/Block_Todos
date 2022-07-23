import 'package:block_todos/app.dart';
import 'package:block_todos/presentation/create_todos/blocs/create_todo_bloc.dart';
import 'package:block_todos/presentation/create_todos/blocs/create_todo_events.dart';
import 'package:block_todos/presentation/create_todos/blocs/create_todo_state.dart';
import 'package:block_todos/utils/app_logger.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data_layer/todos_repository_impl.dart';
import 'components/components.dart';

class CreateTodoPage extends StatelessWidget {
  const CreateTodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (
        context,
      ) =>
          CreateTodosBloc(
        todosRepositoryImple: TodosRepositoryImple(),
      ),
      child: const CreateTodosView(),
    );
  }
}

class CreateTodosView extends StatefulWidget {
  const CreateTodosView({Key? key}) : super(key: key);

  @override
  State<CreateTodosView> createState() => _CreateTodosViewState();
}

class _CreateTodosViewState extends State<CreateTodosView> {
  final taskController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final _createTodosBloc =
        CreateTodosBloc(todosRepositoryImple: TodosRepositoryImple());
    _createTodosBloc.add(const FetchAllTaskEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bloc Todos"),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CreateTodosBloc, CreateTodoState>(
            listener: (context, state) {
              if (state.status.errorCreatingNewTask) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                    ),
                  );
              }
            },
            listenWhen: (prev, current) => prev.status != current.status,
          ),
        ],
        child: Column(
          children: [
            BlocBuilder<CreateTodosBloc, CreateTodoState>(
                builder: (context, state) {
              ///[Loading, Error, Empty List, Non-Empty List]
              if (state.status.isLoading) {
                return const BuildLoadingTodos();
              }
              if (state.status.isError) {
                return BuildErrorLoadingTodos(
                  message: state.errorMessage,
                );
              }
              if (state.status.isIdle) {
                //Check for Emptiness
                if (state.taskList.isNotEmpty) {
                  return Expanded(
                    flex: 4,
                    child: ListView.separated(
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(state.taskList[index].taskName),
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: state.taskList.length,
                    ),
                  );
                }
                return const BuildEmptyTodos();
              }

              return const BuildEmptyTodos();
            }),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 15,
                          top: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      onTap: () {
                        if (taskController.text.isNotEmpty) {
                          context.read<CreateTodosBloc>().add(
                                CreateTaskTodoEvent(taskController.text),
                              );
                        }

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text("Task can not be empty!!"),
                            ),
                          );
                      },
                      child: BlocBuilder<CreateTodosBloc, CreateTodoState>(
                        builder: (context, state) {
                          if (state.status.isIdle) {
                            return Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 70,
                              color: Colors.grey,
                              child: const Text("Add"),
                            );
                          }
                          if (state.status.isCreatingNewTask) {
                            return const Center(
                              child: Text("Load..."),
                            );
                          }
                          return Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 70,
                            color: Colors.grey,
                            child: const Text("Add"),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
