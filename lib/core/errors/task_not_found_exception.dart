import 'package:block_todos/core/errors/failure.dart';

class TaskNotFoundException extends Failure with Exception {
  @override
  String get message => "Task Not Found";
}
