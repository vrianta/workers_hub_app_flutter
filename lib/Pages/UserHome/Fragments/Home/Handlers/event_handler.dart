import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Widget/event_card.dart';

class EventHandler {
  final ApiHandler apiHandler = ApiHandler();
  static List<Event> events = [];
  static List<Event> oldEventsRecord = [];
  static bool isEventsFetched = false;
  static bool isFBgColor = true;
  Color bgColor = Colors.white;

  // Static map to store category image paths
  static const Map<String, String> categoryImagePaths = {
    "birthday": "lib/assets/images/birthday.jpg",
    "meeting": "lib/assets/images/meeting.jpg",
    "conference": "lib/assets/images/conference.jpg",
    "event": "lib/assets/images/event.jpg",
    "party": "lib/assets/images/party.webp",
    "music": "lib/assets/images/music.jpeg",
    "marriage": "lib/assets/images/marriage.jpg",
  };

  Map<String, List<Event>> groupedEvents = {};
  final Function(Event) showEventDetails;

  EventHandler({required this.showEventDetails});

  Future<void> loadData() async {
    await getEventData();
  }

  Future<void> getEventData() async {
    final Map<String, dynamic> jsonObj =
        jsonDecode(await apiHandler.getEvents(events.length - 1));

    if (jsonObj.containsKey("SUCCESS") && jsonObj["SUCCESS"] as bool) {
      if (jsonObj["CODE"] as String == "EVENTS") {
        final List<dynamic> responseEvents = jsonDecode(jsonObj["MESSAGE"]);
        if (responseEvents.isNotEmpty) {
          events.addAll(
              responseEvents.map((json) => Event.fromJson(json)).toList());
        }
      }
    }

    events.sort((a, b) {
      final DateTime dateA = DateTime.parse(a.eventDate);
      final DateTime dateB = DateTime.parse(b.eventDate);
      return dateA.compareTo(dateB);
    });

    oldEventsRecord
      ..clear()
      ..addAll(events);

    isEventsFetched = true;
  }

  Future<void> loadMoreData() async {
    final Map<String, dynamic> jsonObj =
        jsonDecode(await apiHandler.getEvents(events.length - 1));

    if (jsonObj.containsKey("SUCCESS") && jsonObj["SUCCESS"] as bool) {
      if (jsonObj["CODE"] as String == "EVENTS") {
        final List<dynamic> responseEvents = jsonDecode(jsonObj["MESSAGE"]);
        if (responseEvents.isNotEmpty) {
          events.addAll(
              responseEvents.map((json) => Event.fromJson(json)).toList());
        }
      }
    }

    events.sort((a, b) {
      final DateTime dateA = DateTime.parse(a.eventDate);
      final DateTime dateB = DateTime.parse(b.eventDate);
      return dateA.compareTo(dateB);
    });

    oldEventsRecord
      ..clear()
      ..addAll(events);

    isEventsFetched = true;
  }

  Future<Map<String, List<Event>>> getGroupOfEvents() async {
    while (!isEventsFetched) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (groupedEvents.isNotEmpty) {
      groupedEvents.clear();
    }
    for (var event in events) {
      groupedEvents.putIfAbsent(event.eventType, () => []).add(event);
    }

    return groupedEvents;
  }

  String getCategoryImagePath(String eventType) {
    return categoryImagePaths[eventType.toLowerCase()] ??
        'lib/assets/images/default.jpg';
  }

  Future<List<Widget>> getEventCards() async {
    while (!isEventsFetched) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return events.map((event) => eventCard(event, showEventDetails)).toList();
  }

  SizedBox eventTypeCard(String event) {
    final Color fbgColor = const Color.fromARGB(255, 0, 183, 24).withAlpha(40);
    final Color sbgColor = const Color(0xFF6200EE).withAlpha(40);

    bgColor = isFBgColor ? sbgColor : fbgColor;
    isFBgColor = !isFBgColor;

    return SizedBox(
      height: 80,
      width: 95,
      key: Key(event),
      child: Card(
        color: bgColor,
        elevation: 1,
        shadowColor: const Color(0x40000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                event,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 51, 51, 51),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clear() {
    events.clear();
    isEventsFetched = false;
  }

  void filterEvents(String searchText) {
    final searchLower = searchText.toLowerCase();
    final filteredEvents = oldEventsRecord.where((event) {
      final eventName = event.eventName.toLowerCase();
      final eventType = event.eventType.toLowerCase();
      final eventLocation = event.eventLocation.toLowerCase();
      return eventName.contains(searchLower) ||
          eventType.contains(searchLower) ||
          eventLocation.contains(searchLower);
    }).toList();

    events
      ..clear()
      ..addAll(filteredEvents);
  }
}
