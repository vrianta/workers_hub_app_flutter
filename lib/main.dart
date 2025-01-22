import 'package:flutter/material.dart';
import 'package:wo1/Pages/Authentication/Pages/login_ui.dart';

void main() {
  runApp(const ViewController());
}

// Main View Controller which controls all views as a primary view for the application
class ViewController extends StatelessWidget {
  const ViewController({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false, // Enable performance overlay
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
        highlightColor: const Color.fromARGB(
            190, 82, 106, 118), // Primary color for the main theme
        hintColor: const Color.fromARGB(
            255, 118, 154, 172), // Secondary color for the modern app
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: const Color.fromARGB(255, 247, 247, 247), // White app bar
          iconTheme: IconThemeData(color: Colors.deepPurpleAccent),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 247, 247, 247), // White body
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // White bottom navigation bar
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: const Color.fromARGB(130, 124, 77, 255),
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color.fromARGB(255, 231, 231, 231),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
          displayLarge: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ), // Primary header text
          displayMedium: TextStyle(
            fontSize: 20,
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ), // Secondary header text
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      home: const Login(),
    );
  }
}
