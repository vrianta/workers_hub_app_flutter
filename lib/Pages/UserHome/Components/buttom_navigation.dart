import 'package:flutter/material.dart';

class ButtomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const ButtomNavigation({
    required this.currentIndex,
    required this.onTabSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF6200EE),
      selectedItemColor: Colors.white,
      unselectedItemColor: const Color.fromARGB(125, 255, 255, 255),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      onTap: (value) {
        // Invoke the callback to update currentIndex in the parent widget
        onTabSelected(value);
      },
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Dashboard',
          icon: Icon(Icons.dashboard),
        ),
        BottomNavigationBarItem(
          label: 'Notification',
          icon: Icon(Icons.group),
        ),
        BottomNavigationBarItem(
          label: 'Account',
          icon: Icon(Icons.account_box),
        ),
      ],
    );
  }
}
