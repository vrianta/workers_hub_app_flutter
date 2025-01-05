import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';

class Event {
  final String eventID;
  final String eventType;
  final int eventRequirement;
  final int eventBudget;
  final String? eventMinimumHeight;
  final int? eventMinimumRating;
  final int? eventMinimumAge;
  final String eventDate;
  final String eventTime;
  final bool foodProvided;
  final String? eventLanguage;
  final String eventLocation;
  final String ownerID;

  Event({
    required this.eventID,
    required this.eventType,
    required this.eventRequirement,
    required this.eventBudget,
    this.eventMinimumHeight,
    this.eventMinimumRating,
    this.eventMinimumAge,
    required this.eventDate,
    required this.eventTime,
    required this.foodProvided,
    this.eventLanguage,
    required this.eventLocation,
    required this.ownerID,
  });

  // Factory constructor to create an Event from a JSON object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventID: json['EventID'],
      eventType: json['Type'],
      eventRequirement: json['Requirement'],
      eventBudget: json['Budget'],
      eventMinimumHeight: json['MinimumHeight'],
      eventMinimumRating: json['MinimumRating'],
      eventMinimumAge: json['MinimumAge'],
      eventDate: json['Date'],
      eventTime: json['Time'],
      foodProvided:
          json['FoodProvided'] == 1, // Assuming 1 means true and 0 means false
      eventLanguage: json['Language'],
      eventLocation: json['Location'],
      ownerID: json['OwnerID'],
    );
  }
}

class EventHandler {
  ApiHandler apiHandler = ApiHandler();
  static List<Event> events = [];
  static List<String> eventTypes = [];
  static bool isEventsFetched = false;
  static bool isFBgColor = true;
  Color bgColor = Colors.white;

  Map<String, List<Event>> groupedEvents = {};

  Future<void> loadData() async {
    await getEventData();
    getEventTypes();
  }

  // Sample function that simulates gathering event data (e.g., from an API or database)
  Future<void> getEventData() async {
    // Simulating JSON response parsing
    Map<String, dynamic> jsonObj = jsonDecode(await apiHandler.get());

    if (jsonObj.containsKey("SUCCESS") && jsonObj["SUCCESS"] as bool) {
      if (jsonObj["CODE"] as String == "EVENTS") {
        List<dynamic> responseEvents = jsonDecode(jsonObj["MESSAGE"]);
        events = responseEvents.map((json) => Event.fromJson(json)).toList();
      }
    }

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

  // Method to extract unique event types from the events list
  Future<void> getEventTypes() async {
    // Extract event types and remove duplicates using a Set
    while (!isEventsFetched) {
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Non-blocking wait
    }
    eventTypes = events.map((event) => event.eventType).toSet().toList();
  }

  // Function to return a list of Card widgets containing event data
  Future<List<Widget>> getEventCards() async {
    while (!isEventsFetched) {
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // Non-blocking wait
    }
    return events.map((event) {
      return SizedBox(
          child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Type
              Text(
                event.eventType,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8),

              // Event Location
              Text(
                'Location: ${event.eventLocation}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),

              // Event Date and Time
              Text(
                'Date: ${event.eventDate} | Time: ${event.eventTime}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),

              // Event Requirement
              Text(
                'Requirement: ${event.eventRequirement} people',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),

              // Event Budget
              Text(
                'Budget: \$${event.eventBudget}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ));
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
