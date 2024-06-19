import 'package:flutter_di_app/domain/entity/todo_state.dart';
import 'package:flutter_di_app/domain/repository/todo_interface.dart';

class TodoService implements TodoInterface {

  List<TodoState> _todoList = [];

  @override
  void addTodo(TodoState todo) {
    _todoList.add(todo);
  }

  @override
  List<TodoState> getTodo() {
    return List.from(_todoList);
  }

  @override
  void deleteTodo(int id) {
    _todoList.removeWhere((element) => element.id == id);
  }
}