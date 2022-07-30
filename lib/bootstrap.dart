import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:block_todos/app.dart';

import 'package:flutter/material.dart';

void bootstrap() {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runZonedGuarded(
    () async {
      // final todosRepositoryImple = TodosRepositoryImple();
      await BlocOverrides.runZoned(
        () async => runApp(
          const App(),
        ),
        // blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
