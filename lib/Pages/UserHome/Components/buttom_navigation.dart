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
      backgroundColor: Colors.white, // White background color
      selectedItemColor: Colors.black, // Black selected item color
      unselectedItemColor: Colors.black54, // Black unselected item color
      selectedFontSize: 14,
      unselectedFontSize: 14,
      showSelectedLabels: false, // Hide selected labels
      showUnselectedLabels: false, // Hide unselected labels
      onTap: (value) {
        // Invoke the callback to update currentIndex in the parent widget
        onTabSelected(value);
      },
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '', // Removed label
          backgroundColor: Colors.white, // Set background color
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: '', // Removed label
          backgroundColor: Colors.white, // Set background color
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.notifications),
        //   label: '', // Removed label
        //   backgroundColor: Colors.deepPurple, // Set background color
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.account_box),
        //   label: '', // Removed label
        //   backgroundColor: Colors.deepPurple, // Set background color
        // ),
      ],
    );
  }
}
