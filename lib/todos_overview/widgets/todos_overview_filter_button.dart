import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoing/l10n/l10n.dart';
import 'package:todoing/todos_overview/todos_overview.dart';

class TodosOverviewFilterButton extends StatelessWidget {
  const TodosOverviewFilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final activeFilter =
        context.select((TodosOverviewBloc bloc) => bloc.state.filter);
    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      initialValue: activeFilter,
      tooltip: l10n.todosOverviewFilterTooltip,
      onSelected: (filter) {
        context
            .read<TodosOverviewBloc>()
            .add(TodoOverviewFilterChanges(filter));
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text(l10n.todosOverviewFilterAll),
            value: TodosViewFilter.all,
          ),
          PopupMenuItem(
            child: Text(l10n.todosOverviewFilterActiveOnly),
            value: TodosViewFilter.activeOnly,
          ),
          PopupMenuItem(
            child: Text(l10n.todosOverviewFilterCompletedOnly),
            value: TodosViewFilter.completedOnly,
          ),
        ];
      },
      icon: const Icon(
        Icons.filter_list_rounded,
        color: Colors.blue,
      ),
    );
  }
}
