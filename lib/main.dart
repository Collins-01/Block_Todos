import 'package:block_todos/bootstrap.dart';
import 'package:block_todos/core/locator.dart';
import 'package:flutter/material.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  await setUpLocator();
  bootstrap();
}
