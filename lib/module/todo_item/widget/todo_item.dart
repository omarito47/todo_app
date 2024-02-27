import 'package:flutter/material.dart';
import 'package:todo_app/global/global.dart';
import 'package:todo_app/global/widgets/divider_content.dart';
import 'package:todo_app/global/widgets/warningDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoItemPage extends StatefulWidget {
  final TodoItem? existingTodoItem;

  const TodoItemPage({Key? key, this.existingTodoItem}) : super(key: key);

  @override
  State<TodoItemPage> createState() => _TodoItemPageState();
}

class _TodoItemPageState extends State<TodoItemPage> {
  final _formKey = GlobalKey<FormState>();
  String? newTitle;
  String? newDescription;
  String? newType;
  List<TodoItem> todoItems = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.existingTodoItem == null) {
      titleController = TextEditingController();
      descriptionController = TextEditingController();
    } else {
      titleController =
          TextEditingController(text: widget.existingTodoItem!.title);
      descriptionController =
          TextEditingController(text: widget.existingTodoItem!.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.existingTodoItem == null
        ? Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () async {
                      final form = _formKey.currentState;
                      if (form != null && form.validate()) {
                        form.save();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                              onSave: () async {
                                TodoController().addTodoItem(
                                    newTitle!, newDescription!, "", todoItems);

                                Navigator.of(context).pop();

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TodoListPage(),
                                    ));
                                // Close the dialog
                              },
                            );
                          },
                        );
                      }
                    },
                    icon: const Icon(Icons.save_sharp),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  DividerContent(content: "Title"),
                  TextFormField(
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    controller: titleController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                    ),
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
                  DividerContent(content: "Desciption"),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      maxLines: 30, // <-- SEE HERE
                      minLines: 30, // <-- SEE HERE
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Description'),

                      onSaved: (value) {
                        newDescription = value;
                      },
                    ),
                  ),
                ]),
              ),
            ))
        : Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return WarningDialog(
                            onSave: () async {
                              final form = _formKey.currentState;
                              if (form != null && form.validate()) {
                                todoItems =
                                    await TodoController().getTodoItems();
                                form.save();
                                TodoController().editTodoItem(
                                  widget.existingTodoItem!,
                                  newTitle!,
                                  newDescription!,
                                  "",
                                );
                              }
                              Navigator.of(context).pop();

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TodoListPage(),
                                  ));
                              // Close the dialog
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.save_sharp),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  DividerContent(content: "Title"),
                  TextFormField(
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    controller: titleController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                    ),
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
                  DividerContent(content: "Desciption"),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      maxLines: 30, // <-- SEE HERE
                      minLines: 30, // <-- SEE HERE
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Description'),
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
                  ),
                ]),
              ),
            ));
  }
}


//divider widget
