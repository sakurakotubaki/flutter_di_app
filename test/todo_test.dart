import 'package:flutter_di_app/controller/todo_controller.dart';
import 'package:flutter_di_app/domain/entity/todo_state.dart';
import 'package:flutter_di_app/domain/service/todo_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('todo test code', () {
    // DIして、ダミーのデータを入れて、期待しているデータが返ってくるか確認
    final todoService = TodoService();
    final todoController = TodoController(todoService);
    
    // mockのデータを入れて、期待しているデータが返ってくるか確認
    final todo = TodoState(
      id: 1,
      body: 'test',
    );

    // mockのデータを入れて、期待しているデータが返ってくるか確認
    todoController.addTodo(todo);
    // 期待する値が１になるか確認
    expect(todoController.getTodo().length, 1);

    // mockのデータを削除して、期待している値が０になるか確認
    todoController.deleteTodo(1);
    // 期待する値が０になるか確認
    expect(todoController.getTodo().length, 0);
  });
}