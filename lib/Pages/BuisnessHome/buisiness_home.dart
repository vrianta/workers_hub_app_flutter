import 'package:flutter/material.dart';
import 'package:wo1/Alerts/one_exit.dart';

class BuinsessHome extends StatefulWidget {
  const BuinsessHome({super.key});

  @override
  State<BuinsessHome> createState() => _BuinsessHomeState();
}

class _BuinsessHomeState extends State<BuinsessHome> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (c, result) async => {exitConfirmation()},
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Streamline Your Event",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                Text(
                  "Make your events seamless and successful.",
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 1,
            child: FloatingActionButton(
              onPressed: () {
                createEvent();
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void exitConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertOnExit();
      },
    );
  }

  void createEvent() {
    // Add logic to navigate to the event creation screen
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Event'),
          content:
              const Text('This will navigate to the event creation screen.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
