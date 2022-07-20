import 'package:block_todos/core/data_layer/todos_repository_impl.dart';
import 'package:block_todos/core/states/base_viewmodel.dart';
import 'package:block_todos/core/states/view_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpalshScreenViewModel extends BaseViewModel {
  ChangeNotifierProviderRef ref;
  SpalshScreenViewModel(this.ref);
  onModelReady() async {
    try {
      setViewState(const ViewState.busy());
      ref.read(todosRepositoryImple).initiateSetUp();
      setViewState(const ViewState.idle());
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
