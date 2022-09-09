import 'package:bloc/bloc.dart';
import 'package:block_todos/core/domain/todos_repository.dart';
import 'package:block_todos/core/models/task_model.dart';
import 'package:block_todos/core/models/todo_model.dart';
import 'package:block_todos/presentation/create_todos/blocs/blocs.dart';

class CreateTodosBloc extends Bloc<CreateTodoEvent, CreateTodoState> {
  final TodosRepository _todosRepositoryImple;
  CreateTodosBloc({required TodosRepository todosRepositoryImple})
      : _todosRepositoryImple = todosRepositoryImple,
        super(const CreateTodoState()) {
    on<FetchAllTaskEvent>(getAllTasks);
    on<CreateTaskTodoEvent>(createNewtask);
    on<ToggleCompletedTodoEvent>(toggleTaskStatus);
  }

  ///Creates a new Task
  Future<void> createNewtask(CreateTaskTodoEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(status: TodoStatus.isCreatingNewTask));
      await _todosRepositoryImple.createTask(event.taskName);
      //? Should Emit a new list from the Repository
      emit(
        state.copyWith(
            status: TodoStatus.successCreatingNewTask, taskList: () => []),
      );
    } catch (e) {
      emit(
        state.copyWith(
            status: TodoStatus.errorCreatingNewTask,
            errorMessage: 'Failed to Createtask: $e'),
      );
    }
  }

  Stream<List<Todo>> get tasks => _tasks;
  Stream<List<Todo>> get _tasks => _todosRepositoryImple.streamTodoList;
  //Toggles the Status of a task
  Future<void> toggleTaskStatus(
      ToggleCompletedTodoEvent event, Emitter emit) async {
    try {
      emit(
        state.copyWith(status: TodoStatus.loading),
      );
      await _todosRepositoryImple.toggleTodo(event.index, event.isCompleted);
      emit(
        state.copyWith(
          status: TodoStatus.success,
        ),
      );
    } catch (e) {
      //
    }
  }

  ///Get All Tasks List
  Future<void> getAllTasks(FetchAllTaskEvent event, Emitter emit) async {
    try {
      emit(state.copyWith(status: TodoStatus.loading));
      // AppLogger.log("Fetchin Tasks : ${state.status}");
      // await _todosRepositoryImple.getAllTasks();
      // state.copyWith(taskList: () => _tasks);

      // await emit.forEach<List<Task>>(
      //   _todosRepositoryImple.streamTodoList,
      //   onData: (tasks) => state.copyWith(
      //     status: TodoStatus.success,
      //     taskList: () {
      //       return tasks;
      //     },
      //   ),
      //   onError: (e, r) => emit(
      //     state.copyWith(
      //       status: TodoStatus.error,
      //       errorMessage: e.toString(),
      //     ),
      //   ),
      // );
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
