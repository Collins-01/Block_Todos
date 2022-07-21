import 'package:block_todos/core/data_layer/todos_repository_impl.dart';
import 'package:block_todos/core/states/base_viewmodel.dart';
import 'package:block_todos/core/states/view_state.dart';
import 'package:block_todos/presentation/create_todos/create_todos_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpalshScreenViewModel extends BaseViewModel {
  ProviderRef ref;
  SpalshScreenViewModel(this.ref);
  onModelReady(BuildContext context) async {
    try {
      setViewState(const ViewState.busy());
      ref.read(todosRepositoryImple).initiateSetUp();
      setViewState(const ViewState.idle());
      // print(ref.read(todosRepositoryImple).taskList);
      Future.delayed(const Duration(milliseconds: 300));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => CreateTodosView()));
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
