part of 'home_cubit.dart';

enum HomeTab { todos, stats }

class HomeState {
  const HomeState({this.tab = HomeTab.todos});
  final HomeTab tab;
}
