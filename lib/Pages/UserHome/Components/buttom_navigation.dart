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
      backgroundColor: Colors.deepPurple, // Updated background color
      selectedItemColor: Colors.amber, // Updated selected item color
      unselectedItemColor: Colors.white, // Updated unselected item color
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
          icon: Icon(Icons.notifications),
        ),
        BottomNavigationBarItem(
          label: 'Account',
          icon: Icon(Icons.account_box),
        ),
      ],
    );
  }
}
