import 'package:flutter/material.dart';

class BuildErrorLoadingTodos extends StatelessWidget {
  final String message;
  const BuildErrorLoadingTodos(
      {Key? key, this.message = "Failed to load todos"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
