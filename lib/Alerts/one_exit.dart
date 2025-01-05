import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlertOnExit extends StatelessWidget {
  const AlertOnExit({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirm"),
      content: Text("Do you Want to Exit the Application"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No")),
        TextButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}
