import 'package:flutter/material.dart';

class AccountsFragement extends StatelessWidget {
  const AccountsFragement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Accounts Fragement"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
