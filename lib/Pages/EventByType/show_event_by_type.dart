import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/details_of_event.dart';
import 'package:wo1/Widget/event_card.dart';
import 'event_handler.dart';

class ShowEventByType extends StatefulWidget {
  final String eventType;

  const ShowEventByType({super.key, required this.eventType});

  @override
  State<ShowEventByType> createState() => _ShowEventByTypeState();
}

class _ShowEventByTypeState extends State<ShowEventByType> {
  late Future<List<Widget>> eventCards = Future.value([]);
  late final EventByTypeHandler eventHandler;
  int _eventsToShow = 10;
  int _lastShownIndex = 0;
  bool _isLoadingMore = false;
  List<Widget> visibleEventCards = [];

  @override
  void initState() {
    super.initState();
    eventHandler = EventByTypeHandler(showEventDetails: showEventDetails);
    // eventCards = _loadEventsByType();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Widget>> _loadEventsByType() async {
    await eventHandler.loadData(widget.eventType);
    final eventsByType = eventHandler.events;
    return eventsByType.map((event) {
      // eventHandler.showEventDetails(event)
      return eventCard(event, eventHandler.showEventDetails);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events: ${widget.eventType}'),
      ),
      body: FutureBuilder<List<Widget>>(
        future: _loadEventsByType(),
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
              if (index < visibleEventCards.length) {
                return visibleEventCards[index];
              }
              if (visibleEventCards.length >= 10) {
                return _buildLoadMoreButton();
              }
              return Container();
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
                setState(
                  () {
                    _eventsToShow += 10;
                    int maxIndexToshow =
                        min(newEventCards.length, _eventsToShow);
                    visibleEventCards.addAll(
                      newEventCards.sublist(
                        _lastShownIndex,
                        maxIndexToshow,
                      ),
                    );
                    _isLoadingMore = false;
                    _lastShownIndex = maxIndexToshow;
                  },
                );
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
