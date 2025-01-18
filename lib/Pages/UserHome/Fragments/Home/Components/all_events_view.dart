import 'package:flutter/material.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Handlers/event_handler.dart';

class AllEventsView extends StatefulWidget {
  const AllEventsView({
    super.key,
    required this.events,
    required this.listViewController,
    required this.refreshPage,
  });

  final EventHandler events;
  final ScrollController listViewController;
  final Future<void> Function() refreshPage;

  @override
  State<AllEventsView> createState() => _AllEventsViewState();
}

class _AllEventsViewState extends State<AllEventsView> {
  int _eventsToShow = 10;
  int _lastShownIndex = 0;
  bool _isLoadingMore = false;
  List<Widget> visibleEventCards = [];
  Future<List<Widget>> eventCards = Future.value([]);

  @override
  void initState() {
    eventCards = widget.events.getEventCards();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.refreshPage,
      color: Colors.blueAccent,
      child: FutureBuilder<List<Widget>>(
        future: eventCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading event types"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No Event Type Found"),
            );
          }

          if (visibleEventCards.isEmpty) {
            visibleEventCards
                .addAll(snapshot.data!.sublist(_lastShownIndex, _eventsToShow));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.separated(
                controller: widget.listViewController,
                shrinkWrap: true,
                scrollDirection: Axis.vertical, // Changed back to vertical
                itemCount: visibleEventCards.length + 1,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10); // Changed back to height
                },
                itemBuilder: (context, index) {
                  if (index == visibleEventCards.length) {
                    return _buildLoadMoreButton();
                  }
                  return visibleEventCards[index];
                },
              ),
            ),
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
                await widget.events.loadMoreData(); // Load more data
                final newEventCards = await widget.events.getEventCards();
                setState(() {
                  _lastShownIndex = _eventsToShow;
                  _eventsToShow += 10;
                  visibleEventCards.addAll(
                      newEventCards.sublist(_lastShownIndex, _eventsToShow));
                  _isLoadingMore = false;
                });
              },
              child: const Text("Load More"),
            ),
    );
  }
}
