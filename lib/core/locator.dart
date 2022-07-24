import 'package:block_todos/core/data_layer/todos_repository_impl.dart';
import 'package:block_todos/core/repositories/repositories.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  locator.registerLazySingleton<TodosRepository>(() => TodosRepositoryImple());
}
