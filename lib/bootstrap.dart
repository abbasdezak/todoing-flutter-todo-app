import 'dart:async';
import 'dart:developer';

import 'package:todoing/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_api/todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

import 'app/app_bloc_observer.dart';

void bootstrap({required TodosApi todosApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  final todosRepository = TodosRepository(todosApi: todosApi);

  runZonedGuarded(() async {
    await BlocOverrides.runZoned(
      () async => runApp(
        App(todosRepository: todosRepository),
      ),
      blocObserver: AppBlocObserver(),
    );
  }, ((error, stack) => log(error.toString(), stackTrace: stack)));
}
