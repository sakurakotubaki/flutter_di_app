import 'package:flutter/material.dart';
import 'package:flutter_di_app/common/color.dart';
import 'package:flutter_di_app/controller/todo_controller.dart';

import '../domain/entity/todo_state.dart';
import '../domain/service/todo_service.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final bodyController = TextEditingController();
  late TodoController todoController;

  @override
  void initState() {
    super.initState();
    final todoService = TodoService();
    todoController = TodoController(todoService);
  }

  @override
  void dispose() {
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: bodyController,
              decoration: const InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                todoController.addTodo(
                TodoState(
                  id: DateTime.now().millisecondsSinceEpoch,
                  body: bodyController.text,
                ),
              );
              bodyController.clear();
              });
            },
            child: const Text('Add Todo'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoController.getTodo().length,
              itemBuilder: (context, index) {
                final todo = todoController.getTodo()[index];
                return ListTile(
                  title: Text(todo.body ?? 'Not body'),
                  subtitle: Text('${todo.id ?? 'Not id'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      todoController.deleteTodo(todo.id!);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}