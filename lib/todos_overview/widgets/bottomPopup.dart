import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

import '../../edit_todo/bloc/edit_todo_bloc.dart';
import '../../edit_todo/view/edit_todo_page.dart';

class bottomPopup {
  final context;
  final size;
  final Todo? initialTodo;

  bottomPopup({this.context, this.size,this.initialTodo});
  showPopUp() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (BuildContext context) {
          return BlocProvider(
            create: (context) => EditTodoBloc(
              todosRepository: context.read<TodosRepository>(),
              initialTodo: initialTodo,
            ),
            child: Container(
                height: size.height * .7, child: const EditTodoPage()),
          );
        });
  }
}
