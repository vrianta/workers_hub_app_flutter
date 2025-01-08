// Function to show a confirmation dialog
import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(
    BuildContext context, String? description) async {
  bool confirmed = false;
  await showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Application'),
        content: Text(description ?? 'Please Confirm'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // User cancels
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User confirms
              confirmed = true;
            },
            child: Text('Confirm'),
          ),
        ],
      );
    },
  );

  return confirmed; // Return false if dialog is dismissed
}
