import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Task extends Equatable {
  bool isCompleted;
  String taskName;
  Task({
    required this.taskName,
    required this.isCompleted,
  });

  // static const empty = Task(taskName: "_ _", isCompleted: false);

  @override
  List<Object?> get props => [isCompleted, taskName];
}
