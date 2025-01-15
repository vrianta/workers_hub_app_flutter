import 'package:flutter/material.dart';
import 'Pages/Login/login_ui.dart';

void main() {
  runApp(const ViewController());
}

// Main View Controller which controll all my view as a Primary view for my application
class ViewController extends StatelessWidget {
  const ViewController({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
    );
  }
}
