import 'package:flutter/material.dart';
import 'package:my_notes/services/database.dart';

class DeletAlert extends StatelessWidget {
  final String id;
  const DeletAlert({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Confirmation"),
      content: const Text("Are you sure you want to delete this Note?"),
      actions: [
        TextButton(
          onPressed: () async {
            DataBase().deleteNote(id);
            Navigator.of(context).pop();
          },
          child: const Text(
            "Yes",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "No",
          ),
        )
      ],
    );
  }
}
