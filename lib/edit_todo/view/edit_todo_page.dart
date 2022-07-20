// ignore_for_file: prefer_const_constructors

import 'package:todoing/app/app.dart';
import 'package:todoing/edit_todo/bloc/edit_todo_bloc.dart';
import 'package:todoing/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({Key? key}) : super(key: key);

  static Route<void> route({Todo? initialTodo}) {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BlocProvider(
              create: (context) => EditTodoBloc(
                  todosRepository: context.read<TodosRepository>(),
                  initialTodo: initialTodo),
              child: const EditTodoPage(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTodoBloc, EditTodoState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditTodoStatus.success,
      listener: (context, state) {
        Navigator.of(context).pop();
      },
      child: const EditTodoView(),
    );
  }
}

class EditTodoView extends StatelessWidget {
  const EditTodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = context.l10n;
    final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    final isNewTodo =
        context.select((EditTodoBloc bloc) => bloc.state.isNewTodo);
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
            )),
        elevation: 0,
        // title: Text(
        //   isNewTodo
        //       ? l10n.editTodoAddAppBarTitle
        //       : l10n.editTodoEditAppBarTitle,
        //   style: TextStyle(color: Colors.red),
        // ),
      ),
      body: CupertinoScrollbar(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Container(
                child: Column(children: [
                  const _TitleField(),
                  const _DescField(),
                  SizedBox(
                    height:size.height*.1,
                  ),
                  Container(
                    width: size.width * .7,
                    height: size.height*.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          primary: Colors.white,
                          side: const BorderSide(color: Colors.red)),
                      // shape: const ContinuousRectangleBorder(
                      //     borderRadius: BorderRadius.all(Radius.circular(32))),
                      // backgroundColor: status.isLoadingOrSuccess
                      //     ? fabBackgroundColor.withOpacity(0.5)
                      //     : fabBackgroundColor,
                      onPressed: status.isLoadingOrSuccess
                          ? null
                          : () => context
                              .read<EditTodoBloc>()
                              .add(const EditTodoSubmitted()),
                      child: status.isLoadingOrSuccess
                          ? const CupertinoActivityIndicator()
                          :  Text(
                            isNewTodo?
                              "Let's Go": 'Edit',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20,color: Colors.red),
                            ),
                    ),
                  ),
                ]),
                width: size.width * .8),
          ),
        ),
      )),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.title ?? '';
    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
          enabled: !state.status.isLoadingOrSuccess,
          labelText: l10n.editTodoTitleLabel,
          hintText: hintText),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'))
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoTitleChanged(value));
      },
    );
  }
}

class _DescField extends StatelessWidget {
  const _DescField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.description ?? '';
    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
          enabled: !state.status.isLoadingOrSuccess,
          labelText: l10n.editTodoDescriptionLabel,
          hintText: hintText),
      maxLength: 300,
      maxLines: 2,
      inputFormatters: [LengthLimitingTextInputFormatter(300)],
      onChanged: (value) =>
          context.read<EditTodoBloc>().add(EditTOdoDescChanged(value)),
    );
  }
}
