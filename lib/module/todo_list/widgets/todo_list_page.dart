import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/global/database/database_helper.dart';
import 'package:todo_app/global/modals/todo_item.dart';
import 'package:todo_app/global/theme/theme_mode.dart';
import 'package:todo_app/module/todo_item/widget/todo_item.dart';
import 'package:todo_app/module/todo_list/controller/todo_controller.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<TodoItem> todoItems = []; //list of object de type todo item
  final TodoController _todoController = TodoController();

  @override
  void initState() {
    //The reason why super.initState() is called before _loadTodoItems()
    //is to ensure that the parent class's initState() method is executed first.
    //This is important because the parent class's initState()
    //might contain essential initialization logic or setup tasks
    //that need to be executed before the child class's logic.
    super.initState();
    _loadTodoItems();
  }

  Future<void> _loadTodoItems() async {
    List<TodoItem> items = await _todoController.getTodoItems();
    setState(() {
      todoItems = items;
    });
  }

  void editTodoItem(TodoItem todoItem, String newTitle, String newDescription,
      String newType) {
    _todoController.editTodoItem(todoItem, newTitle, newDescription, newType);
    _loadTodoItems();
    Navigator.of(context).pop(); // Close the edit dialog
  }

  void addTodoItem(String title, String description, String type) async {
    _todoController.addTodoItem(title, description, type, todoItems);
    _loadTodoItems(); // Refresh the todo items list
    Navigator.of(context).pop(); // Close the popup after adding the item
  }

  bool isgridview = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          isgridview
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isgridview = false;
                    });
                  },
                  icon: Icon(Icons.grid_view_outlined))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isgridview = true;
                    });
                  },
                  icon: Icon(Icons.list)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Switch(
              value: themeProvider.selectedMode == ThemeModeOptions.Dark,
              onChanged: (value) {
                //you can us e arrow function if  we make the logic into function =>func()
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
      body: isgridview
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of columns in the grid
              ),
              shrinkWrap: true,
              itemCount: todoItems.length,
              itemBuilder: (context, index) {
                TodoItem todoItem = todoItems[index];
                // Generate random height and color values
             
                Color randomColor =
                    Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                        .withOpacity(1.0);
                return SizedBox(
                 
                  child: Padding(
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
                            SnackBar(
                                content: Text("Removed task ${todoItem.title}")),
                          );
                        },
                        child: Container(
                          
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TodoItemPage(existingTodoItem: todoItem),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            todoItem.title,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          // Text(
                                          //     todoItem.description.split("\n")[0])
                                        ],
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                    value: todoItem.completed,
                                    onChanged: (value) {
                                      setState(() {
                                        todoItem.completed = value!;
                                        DatabaseHelper().updateTodoItem(todoItem);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                );
              },
            )
          : ListView.builder(
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
                        SnackBar(
                            content: Text("Removed task ${todoItem.title}")),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
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
                  ),
                );
              },
            ),
      bottomNavigationBar: const BottomAppBar(
        height: 50,
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoItemPage(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
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

 
}
