import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Widget/event_card.dart';

class AppliedEventHandler {
  ApiHandler apiHandler = ApiHandler();
  static List<Event> events = [];
  static List<String> eventTypes = [];
  static bool isEventsFetched = false;
  static bool isFBgColor = true;
  Color bgColor = Colors.white;

  Map<String, List<Event>> groupedEvents = {};
  final Function(Event) showEventDetails;

  AppliedEventHandler({required this.showEventDetails});

  Future<void> loadData() async {
    getAppliedEventData();
  }

  // Sample function that simulates gathering event data (e.g., from an API or database)
  Future<void> getAppliedEventData() async {
    // Simulating JSON response parsing
    Map<String, dynamic> jsonObj =
        jsonDecode(await apiHandler.getAppliedEvents());

    if (jsonObj.containsKey("SUCCESS") && jsonObj["SUCCESS"] as bool) {
      if (jsonObj["CODE"] as String == "EVENTS") {
        List<dynamic> responseEvents = jsonDecode(jsonObj["MESSAGE"]);
        events = responseEvents.map((json) => Event.fromJson(json)).toList();
      }
    }

    // Sorting the events by eventDate asynchronously
    events.sort((a, b) {
      DateTime dateA = DateTime.parse(
          a.eventDate); // assuming eventDate is in a valid format
      DateTime dateB = DateTime.parse(b.eventDate);
      return dateA.compareTo(dateB); // Sort by ascending date
    });

    isEventsFetched = true;
  }

  Future<Map<String, List<Event>>> getGroupOfEvents() async {
    while (!isEventsFetched) {
      await Future.delayed(
        const Duration(milliseconds: 100),
      );
      if (groupedEvents.isNotEmpty) {
        groupedEvents = {};
      }
    }
    groupedEvents = {};
    for (var event in events) {
      groupedEvents.putIfAbsent(event.eventType, () => []).add(event);
    }

    return groupedEvents;
  }

  // Function to return a list of Card widgets containing event data
  Future<List<Widget>> getEventCards() async {
    while (!isEventsFetched) {
      await Future.delayed(
        const Duration(milliseconds: 100),
      );
    }

    return events.map((event) {
      return eventCard(event, showEventDetails);
    }).toList();
  }

  Future<List<Widget>> getEventTypeCards() async {
    while (!isEventsFetched) {
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Non-blocking wait
    }
    return eventTypes.map((event) {
      return eventTypeCard(event);
    }).toList();
  }

  SizedBox eventTypeCard(String event) {
    Color fbgColor = Color.fromARGB(255, 0, 183, 24).withAlpha(40);
    Color sbgColor = Color(0xFF6200EE).withAlpha(40);

    if (isFBgColor) {
      bgColor = sbgColor;
    } else {
      bgColor = fbgColor;
    }
    isFBgColor = !isFBgColor;
    return SizedBox(
      height: 80, // Fixed height for all cards
      width: 95, // Fixed width for all cards
      key: Key(event),
      child: Card(
        color: bgColor,
        elevation: 1,
        shadowColor: Color(0x40000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            children: [
              Text(
                event,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 51, 51, 51),
                ),
                textAlign: TextAlign.center, // Center text horizontally
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clear() {
    events = [];
    eventTypes = [];
    isEventsFetched = false;
  }
}
