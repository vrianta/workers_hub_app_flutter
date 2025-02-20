import 'package:flutter/material.dart';
import 'package:wo1/Alerts/one_exit.dart';
import 'package:wo1/Pages/BuisnessHome/create_event_handler.dart';
import 'package:wo1/Pages/BuisnessHome/view_events_created_by_buisness.dart';

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
          const ViewEventsCreatedByBuisness(),
          createEventButton(context),
        ],
      ),
    );
  }

  Positioned createEventButton(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () {
          createEvent();
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 600,
          child: const CreateEvent(),
        );
      },
    );
  }
}
