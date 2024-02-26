import 'package:todo_app/global/global.dart';
import 'package:flutter/material.dart';
class TodoController {
  Future<List<TodoItem>> getTodoItems() async {
    return await DatabaseHelper().getTodoItems();
  }

  //add todo item
  void addTodoItem(String title, String description, String type,
      List<TodoItem> todoItems) async {
    int newId = todoItems.length + 1;
    TodoItem newTodoItem = TodoItem(
      id: newId,
      title: title,
      description: description,
      type: type,
      completed: false,
    );
    await DatabaseHelper().insertTodoItem(newTodoItem);
  }

  //update todo item
  void editTodoItem(TodoItem todoItem, String newTitle, String newDescription,
      String newType) async {
    todoItem.title = newTitle;
    todoItem.description = newDescription;
    todoItem.type = newType;
    DatabaseHelper().updateTodoItem(todoItem);
  }

  //show dialog to add todo item
  Future<void> showAddTodoItemDialog(BuildContext context,List<TodoItem> todoItems) async {
    final _formKey = GlobalKey<FormState>();
    String? title;
    String? description;
    String? type;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Todo Item'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    description = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Type'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a type';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    type = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final form = _formKey.currentState;
                if (form != null && form.validate()) {
                  form.save();
                  addTodoItem(title!, description!, type!, todoItems!);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditTodoItemDialog(
      TodoItem todoItem, BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String? newTitle;
    String? newDescription;
    String? newType;

    TextEditingController titleController =
        TextEditingController(text: todoItem.title);
    TextEditingController descriptionController =
        TextEditingController(text: todoItem.description);
    TextEditingController typeController =
        TextEditingController(text: todoItem.type);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Todo Item'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newTitle = value;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(hintText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newDescription = value;
                  },
                ),
                TextFormField(
                  controller: typeController,
                  decoration: const InputDecoration(hintText: 'Type'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a type';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newType = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final form = _formKey.currentState;
                if (form != null && form.validate()) {
                  form.save();
                  editTodoItem(todoItem, newTitle!, newDescription!, newType!);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
