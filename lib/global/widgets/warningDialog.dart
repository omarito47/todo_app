import 'package:flutter/material.dart';

class WarningDialog extends StatelessWidget {
  final VoidCallback onSave;

  WarningDialog({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Warning'),
      content: Text('Are you sure you want to save?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: onSave,
          child: Text('Save'),
        ),
      ],
    );
  }
}
