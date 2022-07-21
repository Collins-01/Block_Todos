import 'package:block_todos/core/data_layer/todos_repository_impl.dart';
import 'package:block_todos/presentation/create_todos/blocs/create_todo_events.dart';
import 'package:block_todos/presentation/create_todos/blocs/create_todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTodosBloc extends Bloc<CreateTodoEvent, CreateTodoState> {
  final TodosRepositoryImple _todosRepositoryImple;
  CreateTodosBloc({required TodosRepositoryImple todosRepositoryImple})
      : _todosRepositoryImple = todosRepositoryImple,
        super(const CreateTodoState()) {
    on<CreateTaskTodoEvent>(createNewtask);
  }

  Future<void> createNewtask(CreateTaskTodoEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(status: TodoStatus.loading));
      await _todosRepositoryImple.createTask(event.taskName);
      emit(state.copyWith(status: TodoStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
            status: TodoStatus.error, errorMessage: 'Failed to Createtask: $e'),
      );
    }
  }
  //Get New Task
  //Edit a task Status

  Future<void> toggleTaskStatus(
      ToggleCompletedTodoEvent event, Emitter emit) async {
    try {
      emit(
        state.copyWith(status: TodoStatus.loading),
      );
    } catch (e) {}
  }
}
