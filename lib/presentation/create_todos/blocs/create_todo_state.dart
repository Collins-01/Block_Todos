import 'package:block_todos/core/models/task_model.dart';
import 'package:equatable/equatable.dart';

enum TodoStatus { loading, idle, success, error }

extension XTodoStatus on TodoStatus {
  bool get isLoading => this == TodoStatus.loading;
  bool get isIdle => this == TodoStatus.idle;
  bool get isSuccess => this == TodoStatus.success;
  bool get isError => this == TodoStatus.error;
}

class CreateTodoState extends Equatable {
  final TodoStatus status;
  final String errorMessage;
  final List<Task> taskList;
  const CreateTodoState({
    this.status = TodoStatus.idle,
    this.errorMessage = '',
    this.taskList = const [],
  });

  @override
  List<Object?> get props => [status];

//Copy With method
  CreateTodoState copyWith(
      {TodoStatus? status, String? errorMessage, List<Task>? taskList}) {
    return CreateTodoState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      taskList: taskList ?? this.taskList,
    );
  }
}
