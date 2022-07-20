import 'package:block_todos/core/models/task_model.dart';
import 'package:block_todos/presentation/create_todos/viewmodels/create_todos_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data_layer/todos_repository_impl.dart';

final _createTodosVm = Provider((ref) => CreateTodosViewModel(ref));

class CreateTodosView extends ConsumerWidget {
  const CreateTodosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    var model = ref.watch(_createTodosVm);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bloc Todos"),
      ),
      body: Column(
        children: [
          StreamBuilder<List<Task>>(
              stream: model.tasksList,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                final isNotEmpty =
                    snapshot.data != null && snapshot.data!.isNotEmpty;
                if (isNotEmpty) {
                  return Expanded(
                    flex: 4,
                    child: ListView.separated(
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(snapshot.data![index].taskName),
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: snapshot.data!.length,
                    ),
                  );
                }
                return const Center(
                  child: Text("Empty"),
                );
              }),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: model.taskController,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: InkWell(
                    onTap: () {
                      model.createTask();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 70,
                      color: Colors.grey,
                      child: const Text("Add"),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
