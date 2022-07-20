part of 'todos_overview_bloc.dart';

abstract class TodosOverviewEvent {
  const TodosOverviewEvent();
}

class TodosOverviewSubscriptionRequested extends TodosOverviewEvent {
  const TodosOverviewSubscriptionRequested();
}

class TodosOverviewTodoCompleteionToggled extends TodosOverviewEvent {
  const TodosOverviewTodoCompleteionToggled(
      {required this.todo, required this.isCompleted});
  final Todo todo;
  final bool isCompleted;
}

class TodosOverviewTodoDeleted extends TodosOverviewEvent {
  const TodosOverviewTodoDeleted(this.todo);

  final Todo todo;
}

class TodosOverviewUndoDeletionRequested extends TodosOverviewEvent {
  const TodosOverviewUndoDeletionRequested();
}

class TodoOverviewFilterChanges extends TodosOverviewEvent {
  const TodoOverviewFilterChanges(this.filter);

  final TodosViewFilter filter;
}

class TodosOverviewToggleAllRequested extends TodosOverviewEvent {
  const TodosOverviewToggleAllRequested();
}

class TodosOverviewClearCompletedRequested extends TodosOverviewEvent {
  const TodosOverviewClearCompletedRequested();
}
