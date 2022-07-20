import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos_repository/todos_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(StatsState()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }
  final TodosRepository _todosRepository;

  FutureOr<void> _onSubscriptionRequested(
      StatsSubscriptionRequested event, Emitter<StatsState> emit) async {
    emit(state.copyWith(status: StatsStatus.loading));

    await emit.forEach(_todosRepository.getTodos(),
        onData: (List todos) => state.copyWith(
              status: StatsStatus.success,
              completedTodos: todos.where((todo) => todo.isCompleted).length,
              activeTodos: todos.where((todo) => !todo.isCompleted).length,
            ),
        onError: (_, __) => state.copyWith(status: StatsStatus.failure));
  }
}
