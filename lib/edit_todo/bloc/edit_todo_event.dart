part of 'edit_todo_bloc.dart';

@immutable
abstract class EditTodoEvent {
  const EditTodoEvent();
}

class EditTodoTitleChanged extends EditTodoEvent {
  const EditTodoTitleChanged(this.title);

  final String title;
}

class EditTOdoDescChanged extends EditTodoEvent {
  final String desc;

  const EditTOdoDescChanged(this.desc);
}

class EditTodoSubmitted extends EditTodoEvent {
  const EditTodoSubmitted();
}
