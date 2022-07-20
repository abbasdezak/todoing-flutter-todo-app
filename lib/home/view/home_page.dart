import 'package:todoing/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todoing/todos_overview/widgets/bottomPopup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_repository/todos_repository.dart';
import '../../todos_overview/view/view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const TodosOverviewSubscriptionRequested()),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: TodosOverviewPage(),
      floatingActionButton: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
        builder: (context, state) {
          if (state.todos.isEmpty) {
            if (state.status == TodosOverviewStatus.loading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state.status != TodosOverviewStatus.success) {
              return const SizedBox();
            } else {
              return Center();
            }
          }
          return FloatingActionButton(
            key: const Key('homeView_addTodo_floatingActionButton'),
            onPressed: () =>
                bottomPopup(context: context, size: size).showPopUp(),
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
