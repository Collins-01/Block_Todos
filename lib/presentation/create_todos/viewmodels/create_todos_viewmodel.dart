import 'package:block_todos/core/states/base_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTodosViewModel extends BaseViewModel {
  ChangeNotifierProviderRef ref;
  CreateTodosViewModel(this.ref);
}
