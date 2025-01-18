import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/events.dart';

class EventByTypeHandler {
  final ApiHandler apiHandler = ApiHandler();
  List<Event> events = [];
  static bool isEventsFetched = false;

  // Static map to store category image paths
  static const Map<String, String> categoryImagePaths = {
    "b'day": "lib/assets/images/birthday.jpg",
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
    return events.map((event) {
      return GestureDetector(
        onTap: () => {showEventDetails(event)},
        key: Key(event.eventID),
        child: Hero(
          tag: event.eventID,
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      key: const Key("eventImage"),
                      getCategoryImagePath(event.eventType),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(221, 0, 0, 0),
                            Color.fromARGB(189, 0, 0, 0),
                            Color.fromARGB(119, 0, 0, 0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.event,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  event.eventName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(190, 82, 106, 118),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  event.eventDate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(190, 82, 106, 118),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  event.eventLocation,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(190, 82, 106, 118),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  event.eventTime,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(190, 82, 106, 118),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
