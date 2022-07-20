import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data_layer/todos_repository_impl.dart';

class CreateTodosView extends ConsumerWidget {
  const CreateTodosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bloc Todos"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: ListView.separated(
              itemBuilder: (_, index) => const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Hello"),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: 30,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const Expanded(
                  child: TextField(),
                ),
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: InkWell(
                    onTap: () {
                      ref.read(todosRepositoryImple).initiateSetUp();
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
