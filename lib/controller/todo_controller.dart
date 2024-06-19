import 'package:flutter_di_app/domain/entity/todo_state.dart';
import 'package:flutter_di_app/domain/service/todo_service.dart';

class TodoController {
  final TodoService _todoService;

  TodoController(this._todoService);

  void addTodo(TodoState todo) {
    _todoService.addTodo(todo);
  }

  List<TodoState> getTodo() {
    return _todoService.getTodo();
  }

  void deleteTodo(int id) {
    _todoService.deleteTodo(id);
  }
}