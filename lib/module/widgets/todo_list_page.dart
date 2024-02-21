import 'package:flutter/material.dart';
import 'package:todo_app/global/database/database_helper.dart';
import 'package:todo_app/global/modals/todo_item.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
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
                child: Icon(Icons.delete_forever),
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
                shape: LinearBorder.bottom(
                    side: BorderSide(color: Colors.black), size: .9),
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
                    icon: Icon(Icons.edit_outlined)),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(side: BorderSide(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        onPressed: _showAddTodoItemDialog,
        child: Icon(Icons.add, color: Colors.white),
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
          title: Text('Edit Todo Item'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Title'),
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
                  decoration: InputDecoration(hintText: 'Description'),
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
                  decoration: InputDecoration(hintText: 'Type'),
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final form = _formKey.currentState;
                if (form != null && form.validate()) {
                  form.save();
                  editTodoItem(todoItem, newTitle!, newDescription!, newType!);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddTodoItemDialog() async {
    final _formKey = GlobalKey<FormState>();
    String? title;
    String? description;
    String? type;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Todo Item'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(hintText: 'Title'),
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
                  decoration: InputDecoration(hintText: 'Description'),
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
                  decoration: InputDecoration(hintText: 'Type'),
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final form = _formKey.currentState;
                if (form != null && form.validate()) {
                  form.save();
                  addTodoItem(title!, description!, type!);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
