import 'package:flutter/material.dart';

class DividerContent extends StatefulWidget {
  String content;
  DividerContent({super.key, required this.content});

  @override
  State<DividerContent> createState() => _DividerState();
}

class _DividerState extends State<DividerContent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 20,
        ),
        Flexible(
          child: Divider(
            indent: MediaQuery.of(context).size.width * .1,
            endIndent: MediaQuery.of(context).size.width * .05,
            color: Color.fromARGB(255, 188, 188, 188),
            height: 10,
          ),
        ),
        Text(
          "${widget.content}",
          style: TextStyle(color: Color.fromARGB(255, 188, 188, 188)),
        ),
        Flexible(
          child: Divider(
            indent: MediaQuery.of(context).size.width * .05,
            endIndent: MediaQuery.of(context).size.width * .1,
            color: Color.fromARGB(255, 188, 188, 188),
            height: 10,
          ),
        ),
      ],
    );
  }
}
