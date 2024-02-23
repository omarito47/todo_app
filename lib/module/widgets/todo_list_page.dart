import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/global/database/database_helper.dart';
import 'package:todo_app/global/modals/todo_item.dart';
import 'package:todo_app/global/theme/theme_mode.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<TodoItem> todoItems = [];
  @override
  void initState() {
    super.initState();
    getTodoItems();
  }

  Future<void> getTodoItems() async {
    List<TodoItem> items = await DatabaseHelper().getTodoItems();
    setState(() {
      todoItems = items;
    });
  }

  void editTodoItem(TodoItem todoItem, String newTitle, String newDescription,
      String newType) {
    setState(() {
      todoItem.title = newTitle;
      todoItem.description = newDescription;
      todoItem.type = newType;
      DatabaseHelper().updateTodoItem(todoItem);
    });
    Navigator.of(context).pop(); // Close the edit dialog
  }

  void addTodoItem(String title, String description, String type) async {
    int newId = todoItems.length + 1;
    TodoItem newTodoItem = TodoItem(
      id: newId,
      title: title,
      description: description,
      type: type,
      completed: false,
    );
    await DatabaseHelper().insertTodoItem(newTodoItem);
    getTodoItems(); // Refresh the todo items list
    Navigator.of(context).pop(); // Close the popup after adding the item
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Switch(
              value: themeProvider.selectedMode == ThemeModeOptions.Dark,
              onChanged: (value) {
                if (value) {
                  themeProvider.setThemeMode(ThemeModeOptions.Dark);
                } else {
                  themeProvider.setThemeMode(ThemeModeOptions.Light);
                }
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          TodoItem todoItem = todoItems[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Dismissible(
              background: Container(
                color: Colors.red,
                child: const Stack(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.delete_forever),
                        )),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.delete_forever),
                        )),
                  ],
                ),
              ),
              key: Key("${todoItem.id}"),
              onDismissed: (direction) {
                setState(() {
                  todoItems.removeAt(index);
                  DatabaseHelper().deleteTodoItem(todoItem.id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Removed task ${todoItem.title}")),
                );
              },
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                tileColor: Colors.grey,
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Checkbox(
                  value: todoItem.completed,
                  onChanged: (value) {
                    setState(() {
                      todoItem.completed = value!;
                      DatabaseHelper().updateTodoItem(todoItem);
                    });
                  },
                ),
                title: Text(todoItem.title),
                subtitle: Text(todoItem.description),
                trailing: IconButton(
                  onPressed: () {
                    showEditTodoItemDialog(todoItem);
                  },
                  icon: const Icon(Icons.edit_outlined),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(side: BorderSide(color: Colors.white)),
        
        onPressed: showAddTodoItemDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> showEditTodoItemDialog(TodoItem todoItem) async {
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

  Future<void> showAddTodoItemDialog() async {
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
                  addTodoItem(title!, description!, type!);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
