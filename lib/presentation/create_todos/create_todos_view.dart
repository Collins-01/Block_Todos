import 'package:block_todos/presentation/create_todos/blocs/create_todo_bloc.dart';
import 'package:block_todos/presentation/create_todos/blocs/create_todo_events.dart';
import 'package:block_todos/presentation/create_todos/blocs/create_todo_state.dart';

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
        todosRepositoryImple: context.read<TodosRepositoryImple>(),
      )..add(const FetchAllTaskEvent()),
      child: CreateTodosView(),
    );
  }
}

class CreateTodosView extends ConsumerWidget {
  CreateTodosView({Key? key}) : super(key: key);
  final taskController = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {
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
                        // model.createTask();
                        if (taskController.text.isNotEmpty) {
                          context.read<CreateTodosBloc>().add(
                                CreateTaskTodoEvent(taskController.text),
                              );
                        }
                        if (taskController.text.length < 5) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text("Task should be 5+ chars!"),
                              ),
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
