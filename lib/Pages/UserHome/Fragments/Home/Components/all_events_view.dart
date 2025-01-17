import 'package:flutter/material.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/event_handler.dart';

class AllEventsView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshPage,
      color: Colors.blueAccent,
      child: FutureBuilder<List<Widget>>(
        future: events.getEventCards(),
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

          List<Widget>? eventCards = snapshot.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.separated(
                controller: listViewController,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: eventCards!.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return eventCards[index];
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
