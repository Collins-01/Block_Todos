import 'package:equatable/equatable.dart';

class CreateTodoEvent extends Equatable {
  const CreateTodoEvent();

  @override
  List<Object?> get props => [];
}

class FetchingTasksEvent extends CreateTodoEvent {
  const FetchingTasksEvent();
  @override
  List<Object?> get props => [];
}

class ToggleCompletedTodoEvent extends CreateTodoEvent {
  final bool isCompleted;
  const ToggleCompletedTodoEvent(this.isCompleted);
  @override
  List<Object?> get props => [isCompleted];
}

class CreateTaskTodoEvent extends CreateTodoEvent {
  final String taskName;
  final bool isCompleted;
  const CreateTaskTodoEvent(this.taskName, [this.isCompleted = false]);
  @override
  List<Object?> get props => [taskName, isCompleted];
}
