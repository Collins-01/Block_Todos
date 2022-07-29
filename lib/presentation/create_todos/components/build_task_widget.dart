import 'package:block_todos/core/models/models.dart';
import 'package:flutter/material.dart';
import '../../../extensions/extensions.dart';

class BuildTaskWidget extends StatelessWidget {
  final Task task;
  final Function(bool? value)? toggleTask;
  const BuildTaskWidget({Key? key, required this.task, this.toggleTask})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 5),
      child: Container(
        height: 100,
        width: context.getDeviceWidth,
        decoration: const BoxDecoration(
          color: Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  task.taskName,
                ),
              ),
              const Spacer(),
              Checkbox(
                value: task.isCompleted,
                onChanged: toggleTask,
              )
            ],
          ),
        ),
      ),
    );
  }
}
