import 'package:block_todos/core/models/todo_model.dart';
import 'package:equatable/equatable.dart';

enum TodoStatus {
  loading,
  idle,
  success,
  error,
  isCreatingNewTask,
  successCreatingNewTask,
  errorCreatingNewTask,
  idleCreatingTask
}

extension XTodoStatus on TodoStatus {
  bool get isLoading => this == TodoStatus.loading;
  bool get isIdle => this == TodoStatus.idle;
  bool get isSuccess => this == TodoStatus.success;
  bool get isError => this == TodoStatus.error;
  bool get isCreatingNewTask => this == TodoStatus.isCreatingNewTask;
  bool get successCreatingNewTask => this == TodoStatus.successCreatingNewTask;
  bool get errorCreatingNewTask => this == TodoStatus.errorCreatingNewTask;
  bool get idleCreatingTask => this == TodoStatus.idleCreatingTask;
}

class CreateTodoState extends Equatable {
  final TodoStatus status;
  final String errorMessage;
  final List<Todo> taskList;
  final Stream<List<Todo>> streamtaskList;
  const CreateTodoState({
    this.status = TodoStatus.idle,
    this.errorMessage = '',
    this.taskList = const [],
    this.streamtaskList = const Stream.empty(),
  });

  @override
  List<Object?> get props => [status];

//Copy With method
  CreateTodoState copyWith(
      {TodoStatus? status,
      String? errorMessage,
      List<Todo> Function()? taskList,
      Stream<List<Todo>> Function()? streamtaskList}) {
    return CreateTodoState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      taskList: taskList != null ? taskList() : this.taskList,
      streamtaskList:
          streamtaskList != null ? streamtaskList() : this.streamtaskList,
    );
  }
}
