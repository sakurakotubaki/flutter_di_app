import 'package:flutter_di_app/domain/entity/todo_state.dart';

// 実装がされていないinterface
abstract interface class TodoInterface {
  void addTodo(TodoState todo);
  List<TodoState> getTodo();
  void deleteTodo(int id);
}