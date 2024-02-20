// import 'package:flutter/material.dart';
// import 'package:todo_app/global/constants/constant.dart';

// import '../modals/todo_item.dart';

// class TodoItemCard extends StatefulWidget {
//   final TodoItem todo;
//   // final onToDoChanged;
//   // final onDeleteItem;

//   const TodoItemCard({
//     Key? key,
//     required this.todo,
//     // required this.onToDoChanged,
//     // required this.onDeleteItem,
//   }) : super(key: key);

//   @override
//   State<TodoItemCard> createState() => _TodoItemCardState();
// }

// class _TodoItemCardState extends State<TodoItemCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 15.0),
//       margin: EdgeInsets.only(bottom: 15),
//       child: ListTile(
//         onTap: () {
//           print("Done !!!");
//         },
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         tileColor: Colors.white,
//         leading: Icon(Icons.check_box_outline_blank, color: tdBlue),
//         title: Text("${widget.todo.title}"),
//         trailing: Container(
//           height: 35,
//           width: 40,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5), color: Colors.red),
//           child: IconButton(
//             icon: Icon(
//               Icons.delete,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               print("object deleted!!!");
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
