import 'package:block_todos/core/states/base_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTodosViewModel extends BaseViewModel {
  ProviderRef ref;
  CreateTodosViewModel(this.ref);
  final taskController = TextEditingController();
  // Stream<List<Task>> get tasksList =>
  //     ref.watch(todosRepositoryImple).streamTodoList;

  Future<void> createTask() async {
    try {
      if (taskController.text.isNotEmpty) {
        // await ref.read(todosRepositoryImple).createTask(taskController.text);
        taskController.clear();
      }
    } catch (e) {
      print("Error ---- $e");
    }
  }
}
