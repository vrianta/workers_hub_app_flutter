import 'package:flutter/material.dart';

class DashboardFragement extends StatefulWidget {
  const DashboardFragement({super.key});

  @override
  State<DashboardFragement> createState() => _DashboardFragementState();
}

class _DashboardFragementState extends State<DashboardFragement> {
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
                Text("Dashboard Fragement"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
