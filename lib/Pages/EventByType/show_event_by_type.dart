import 'package:flutter/material.dart';
import 'event_handler.dart';

class ShowEventByType extends StatefulWidget {
  final String eventType;

  const ShowEventByType({super.key, required this.eventType});

  @override
  _ShowEventByTypeState createState() => _ShowEventByTypeState();
}

class _ShowEventByTypeState extends State<ShowEventByType> {
  late Future<List<Widget>> eventCards;
  final EventByTypeHandler eventHandler =
      EventByTypeHandler(showEventDetails: (event) {});

  @override
  void initState() {
    super.initState();
    eventCards = _loadEventsByType();
  }

  Future<List<Widget>> _loadEventsByType() async {
    await eventHandler.loadData(widget.eventType);
    final eventsByType = eventHandler.events
        .where((event) => event.eventType == widget.eventType)
        .toList();
    return eventsByType.map((event) {
      return GestureDetector(
        onTap: () => {eventHandler.showEventDetails(event)},
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
                      eventHandler.getCategoryImagePath(event.eventType),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events: ${widget.eventType}'),
      ),
      body: FutureBuilder<List<Widget>>(
        future: eventCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading events"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No Events Found"),
            );
          }
          return ListView(
            children: snapshot.data!,
          );
        },
      ),
    );
  }
}
