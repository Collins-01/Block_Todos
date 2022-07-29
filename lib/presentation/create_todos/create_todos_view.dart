import 'package:block_todos/core/domain_layer/repositories/repositories.dart';
import 'package:block_todos/core/models/task_model.dart';
import 'package:block_todos/presentation/create_todos/blocs/create_todo_bloc.dart';
import 'package:block_todos/presentation/create_todos/blocs/create_todo_events.dart';
import 'package:block_todos/presentation/create_todos/blocs/create_todo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/build_task_widget.dart';
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
        todosRepositoryImple: context.read<TodosRepository>(),
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
            // Body that contains Tasks
            BlocBuilder<CreateTodosBloc, CreateTodoState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                return Expanded(
                  flex: 4,
                  child: StreamBuilder(
                    stream: context.read<CreateTodosBloc>().tasks,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data as List<Task>;

                        if (data.isNotEmpty) {
                          return ListView.separated(
                            itemBuilder: (_, index) {
                              return BuildTaskWidget(
                                task: data[index],
                              );
                            },
                            separatorBuilder: (__, index) => const Divider(),
                            itemCount: data.length,
                          );
                          // return Center(
                          //   child: Text(
                          //     data.toString(),
                          //   ),
                          // );
                        }
                        return const Center(child: BuildEmptyTodos());
                        // :

                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Text("!snapshot.hasData");
                      }
                      return Center(
                        child: Text(snapshot.connectionState.toString()),
                      );
                    },
                  ),
                );
              },
            ),
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
                          taskController.clear();
                        } else {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text("Task can not be empty!!"),
                              ),
                            );
                        }
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
