import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Widget/event_card.dart';

class EventByTypeHandler {
  final ApiHandler apiHandler = ApiHandler();
  List<Event> events = [];
  static bool isEventsFetched = false;

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

  final Function(Event) showEventDetails;

  EventByTypeHandler({required this.showEventDetails});

  Future<void> loadData(String eventType) async {
    await getEventData(eventType);
  }

  Future<void> getEventData(String eventType) async {
    final Map<String, dynamic> jsonObj = jsonDecode(
        await apiHandler.getEventsByType(events.length - 1, eventType));

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

    isEventsFetched = true;
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
}
