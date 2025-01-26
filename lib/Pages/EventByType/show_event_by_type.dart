import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/details_of_event.dart';
import 'event_handler.dart';

class ShowEventByType extends StatefulWidget {
  final String eventType;

  const ShowEventByType({super.key, required this.eventType});

  @override
  State<ShowEventByType> createState() => _ShowEventByTypeState();
}

class _ShowEventByTypeState extends State<ShowEventByType> {
  late Future<List<Widget>> eventCards;
  late final EventByTypeHandler eventHandler;
  int _eventsToShow = 10;
  int _lastShownIndex = 0;
  bool _isLoadingMore = false;
  List<Widget> visibleEventCards = [];

  @override
  void initState() {
    super.initState();
    eventHandler = EventByTypeHandler(showEventDetails: showEventDetails);
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

          if (visibleEventCards.isEmpty) {
            visibleEventCards.addAll(snapshot.data!.sublist(
                _lastShownIndex, min(snapshot.data!.length, _eventsToShow)));
          }

          return ListView.separated(
            itemCount: visibleEventCards.length + 1,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index == visibleEventCards.length) {
                return _buildLoadMoreButton();
              }
              return visibleEventCards[index];
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Center(
      child: _isLoadingMore
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoadingMore = true;
                });
                await eventHandler.loadData(widget.eventType); // Load more data
                final newEventCards = await _loadEventsByType();
                setState(() {
                  _lastShownIndex = _eventsToShow;
                  _eventsToShow += 10;
                  visibleEventCards.addAll(newEventCards.sublist(
                      _lastShownIndex,
                      min(newEventCards.length, _eventsToShow)));
                  _isLoadingMore = false;
                });
              },
              child: const Text("Load More"),
            ),
    );
  }

  void showEventDetails(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(
          event: event,
          onClose: () => {Navigator.pop(context)},
        ),
      ),
    );
  }

  refreshPage() {}
}
