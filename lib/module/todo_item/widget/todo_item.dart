import 'package:flutter/material.dart';
import 'package:todo_app/global/global.dart';

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
                widget.existingTodoItem == null
                    ? IconButton(
                        onPressed: () async {
                          print("hello !");
                          final form = _formKey.currentState;
                          if (form != null && form.validate()) {
                            todoItems = await TodoController().getTodoItems();
                            form.save();
                            TodoController().addTodoItem(
                                newTitle!, newDescription!, "", todoItems);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TodoListPage(),
                                ));
                          }
                        },
                        icon: const Icon(Icons.save_sharp))
                    : IconButton(
                        onPressed: () async {
                          print("hello !");
                          final form = _formKey.currentState;
                          if (form != null && form.validate()) {
                            todoItems = await TodoController().getTodoItems();
                            form.save();
                            TodoController().editTodoItem(
                                widget.existingTodoItem!,
                                newTitle!,
                                newDescription!,
                                "");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TodoListPage(),
                                ));
                          }
                        },
                        icon: const Icon(Icons.save_sharp))
              ],
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    controller: titleController,
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
                  TextFormField(
                    maxLines: 30, // <-- SEE HERE
                    minLines: 30, // <-- SEE HERE
                    controller: descriptionController,
                    decoration: const InputDecoration(hintText: 'Description', border: InputBorder.none,),
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
                ]),
              ),
            ))
        : Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      print("hello !");
                      final form = _formKey.currentState;
                      if (form != null && form.validate()) {
                        todoItems = await TodoController().getTodoItems();
                        form.save();
                        TodoController().editTodoItem(widget.existingTodoItem!,
                            newTitle!, newDescription!, "");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodoListPage(),
                            ));
                      }
                    },
                    icon: const Icon(Icons.save_sharp))
              ],
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    controller: titleController,
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
                  TextFormField(
                    maxLines: 30, // <-- SEE HERE
                    minLines: 30, // <-- SEE HERE
                    controller: descriptionController,
                    decoration: const InputDecoration( border: InputBorder.none,hintText: 'Description'),
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
                ]),
              ),
            ));
  }
}
