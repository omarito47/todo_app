import 'package:flutter/material.dart';
import 'package:todo_app/global/modals/todo_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<TodoItem> todoItems = [];

  @override
  void initState() {
    super.initState();
    // Add some initial todo items
    todoItems.add(TodoItem(
      id: 1,
      title: 'Task 1',
      description: 'Description 1',
      type: 'Type 1',
    ));
    todoItems.add(TodoItem(
      id: 2,
      title: 'Task 2',
      description: 'Description 2',
      type: 'Type 2',
    ));
    todoItems.add(TodoItem(
      id: 3,
      title: 'Task 3',
      description: 'Description 3',
      type: 'Type 3',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              color: Colors.red,
            ),
            key: new Key("${todoItems[index].id}"),
            onDismissed: (direction) {
              todoItems.removeAt(index);
              // SnackBar(content: Text("Removed task ${todoItems[index].title}"));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Removed task ${todoItems[index].title}")));
            },
            child: ListTile(
              leading: Checkbox(
                value: todoItems[index].completed,
                onChanged: (value) {
                  setState(() {
                    todoItems[index].completed = value!;
                  });
                },
              ),
              title: Text(todoItems[index].title),
              subtitle: Text(todoItems[index].description),
              trailing: Text(todoItems[index].type),
            ),
          );
        },
      ),
    );
  }
}
