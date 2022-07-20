part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

@immutable
 class StatsState {
  final StatsStatus status;
  final int completedTodos;
  final int activeTodos;

  const StatsState(
      {this.status = StatsStatus.initial,
      this.completedTodos = 0,
      this.activeTodos = 0});

  StatsState copyWith({
    StatsStatus? status,
    int? completedTodos,
    int? activeTodos,
  }) {
    return StatsState(
        status: status ?? this.status,
        completedTodos: completedTodos ?? this.completedTodos,
        activeTodos: activeTodos ?? this.activeTodos);
  }
}
