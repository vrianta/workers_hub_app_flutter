import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wo1/Models/events.dart';

Widget eventCard(Event event, Function(Event) showEventDetails) {
  return GestureDetector(
    onTap: () {
      Fluttertoast.showToast(
        msg: "Opening event details...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
      showEventDetails(event);
    },
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
}

String getCategoryImagePath(String eventType) {
  const Map<String, String> categoryImagePaths = {
    "b'day": "lib/assets/images/birthday.jpg",
    "meeting": "lib/assets/images/meeting.jpg",
    "conference": "lib/assets/images/conference.jpg",
    "event": "lib/assets/images/event.jpg",
    "party": "lib/assets/images/party.webp",
    "music": "lib/assets/images/music.jpeg",
    "marriage": "lib/assets/images/marriage.jpg",
  };

  return categoryImagePaths[eventType.toLowerCase()] ??
      'lib/assets/images/default.jpg';
}
