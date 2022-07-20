import 'package:todoing/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todoing/todos_overview/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:todoing/l10n/l10n.dart';

import '../../edit_todo/bloc/edit_todo_bloc.dart';
import '../../edit_todo/view/edit_todo_page.dart';
import '../../stats/bloc/stats_bloc.dart';
import '../widgets/bottomPopup.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodosOverviewBloc(
            todosRepository: context.read<TodosRepository>(),
          )..add(const TodosOverviewSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) =>
              StatsBloc(todosRepository: context.read<TodosRepository>())
                ..add(const StatsSubscriptionRequested()),
        )
      ],
      child: const TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final statsState = context.watch<StatsBloc>().state;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.todosOverviewAppBarTitle,
          style: const TextStyle(color: Colors.red),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          const TodosOverviewFilterButton(),
          const TodosOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Text(l10n.todosOverviewErrorSnackbarText)));
              }
            },
          ),
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTodo != current.lastDeletedTodo &&
                current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(l10n
                      .todosOverviewTodoDeletedSnackbarText(deletedTodo.title)),
                  action: SnackBarAction(
                    label: l10n.todosOverviewUndoDeletionButtonText,
                    onPressed: () {
                      messenger.hideCurrentSnackBar();
                      context
                          .read<TodosOverviewBloc>()
                          .add(const TodosOverviewUndoDeletionRequested());
                    },
                  ),
                ));
            },
            child: Container(),
          )
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else if (state.status != TodosOverviewStatus.success) {
                return const SizedBox();
              } else {
                return const Center(child: const EmptyTodos());
              }
            }
            return CupertinoScrollbar(
                child: Stack(
              children: [
                Positioned(
                  left: -size.height * .5,
                  top: size.height * .04,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 255, 246, 249)),
                  ),
                ),
                Positioned(
                  left: size.height * .05,
                  top: size.height * .04,
                  child: Text(
                    '${statsState.activeTodos}',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: size.height * .12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: size.height * .05,
                  top: size.height * .2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'tasks for\ntoday',
                        style: TextStyle(
                            fontSize: size.height * .06,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(Icons.check,
                              color: Colors.green, size: size.height * .028),
                          Text(
                            ' ${statsState.completedTodos} tasks done ',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: size.height * .025,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                      child: ListView(
                        children: [
                          for (var todo in state.filteredTodos)
                            Column(
                              children: [
                                TodoListTile(
                                  todo: todo,
                                  onToggleCompleted: (isCompleted) {
                                    context.read<TodosOverviewBloc>().add(
                                        TodosOverviewTodoCompleteionToggled(
                                            todo: todo,
                                            isCompleted: isCompleted));
                                  },
                                  onDismissed: (_) {
                                    context
                                        .read<TodosOverviewBloc>()
                                        .add(TodosOverviewTodoDeleted(todo));
                                  },
                                  onTap: () {
                                    bottomPopup(
                                            context: context,
                                            size: size,
                                            initialTodo: todo)
                                        .showPopUp();
                                  },
                                ),
                                Container(
                                    width: size.width * .9,
                                    child: Divider(
                                      height: size.height * .04,
                                      thickness: 1,
                                    ))
                              ],
                            )
                        ],
                      ),
                      width: size.width,
                      height: size.height * .4,
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 214, 214, 214),
                              blurRadius: 10,
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)))),
                )
              ],
            ));
          },
        ),
      ),
    );
  }
}

class EmptyTodos extends StatelessWidget {
  const EmptyTodos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: size.width * .3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * .1,
          ),
          Text(
            'Hey',
            style: TextStyle(
                fontSize: size.height * .07,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
          Text(
            'you are\nfree today!',
            style: TextStyle(
                fontSize: size.height * .07, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * .02,
          ),
          // Text(
          //   'Last day you finished\n08 tasks',
          //   style: TextStyle(fontSize: size.height * .03, color: Colors.grey),
          // ),
          SizedBox(
            height: size.height * .05,
          ),
          Container(
            width: size.width * .7,
            height: size.height * .08,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    primary: Colors.white,
                    side: const BorderSide(color: Colors.red)),
                onPressed: () {
                  bottomPopup(context: context, size: size).showPopUp();
                },
                child: Text('Add new task',
                    style: TextStyle(
                        fontSize: size.height * .03, color: Colors.red))),
          )
        ],
      ),
    );
  }
}
