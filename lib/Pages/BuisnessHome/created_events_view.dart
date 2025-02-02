import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Widget/event_card.dart';

class CreatedEventsView extends StatefulWidget {
  const CreatedEventsView({
    super.key,
  });
  @override
  State<CreatedEventsView> createState() => _CreatedEventsViewState();
}

class _CreatedEventsViewState extends State<CreatedEventsView> {
  late ApiHandler apiHandler;
  late final CreatedEventsView createdEventView;
  late Future<List<Event>> allCreatedEvents;
  @override
  void initState() {
    apiHandler = ApiHandler();
    allCreatedEvents = getEventData();
    super.initState();
  }

  Future<List<Event>> getEventData() async {
    final Map<String, dynamic> jsonObj =
        jsonDecode(await apiHandler.getEvents(0));

    if (jsonObj.containsKey("SUCCESS") && jsonObj["SUCCESS"] as bool) {
      if (jsonObj["CODE"] as String == "CREATEDEVENTS") {
        final List<dynamic> responseEvents = jsonDecode(jsonObj["MESSAGE"]);
        return responseEvents.map((json) => Event.fromJson(json)).toList();
      }
    }

    return [];
  }

  Future<void> refresh() async {
    setState(() {
      allCreatedEvents = Future.value([]);
      allCreatedEvents = getEventData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Padding _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Streamline Your Event",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            "Make your events seamless and successful.",
            style: TextStyle(
              color: Theme.of(context).highlightColor,
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                refresh();
              },
              color: Theme.of(context).primaryColor,
              child: FutureBuilder<List<Event>>(
                future: allCreatedEvents,
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
                      child: Text("No Events Created"),
                    );
                  }

                  List<Event>? eventCards = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: SizedBox(
                      child: ListView.builder(
                        shrinkWrap: false,
                        padding: EdgeInsets.all(0),
                        scrollDirection: Axis.vertical,
                        itemCount: eventCards.length,
                        itemBuilder: (context, index) {
                          return allCreatedEventsCard(
                              eventCards[index], _showDetailsofEvent, 1);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showDetailsofEvent(Event p1) {}
}
