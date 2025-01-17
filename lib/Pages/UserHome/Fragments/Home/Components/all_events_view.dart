import 'package:flutter/material.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/event_handler.dart';

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
  _AllEventsViewState createState() => _AllEventsViewState();
}

class _AllEventsViewState extends State<AllEventsView> {
  int _eventsToShow = 10;
  int _oldEventsToShow = 0;
  int totalEvents = 0;
  bool _isLoadingMore = false;
  List<Widget> visibleEventCards = [];
  Future<List<Widget>> eventCards = Future.value([]);

  @override
  void initState() {
    eventCards = widget.events.getEventCards();
    eventCards.then((cards) {
      setState(() {
        totalEvents = cards.length;
      });
    });
    super.initState();
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

          visibleEventCards.addAll(snapshot.data!.sublist(0, _eventsToShow));

          //eventCards!.sublist(0, _eventsToShow);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.separated(
                controller: widget.listViewController,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: visibleEventCards.length + 1,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
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
    if (_eventsToShow >= totalEvents) {
      return const SizedBox.shrink();
    }

    return Center(
      child: _isLoadingMore
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoadingMore = true;
                });
                await Future.delayed(const Duration(seconds: 1));
                setState(() {
                  _oldEventsToShow = _eventsToShow;
                  _eventsToShow = (_eventsToShow + 10).clamp(0, totalEvents);
                  _isLoadingMore = false;
                });
                widget.listViewController.animateTo(
                  widget.listViewController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text("Load More"),
            ),
    );
  }
}
