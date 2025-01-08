import 'package:flutter/material.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/event_handler.dart';

class EventsCatagoryView extends StatelessWidget {
  const EventsCatagoryView({
    super.key,
    required this.events,
    required this.catagoryScrollController,
  });

  final EventHandler events;
  final ScrollController catagoryScrollController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: events.getEventTypeCards(),
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

        List<Widget>? eventTypesCards = snapshot.data;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: EventCatagoryCardsView(
            catagoryScrollController: catagoryScrollController,
            eventTypesCards: eventTypesCards,
          ),
        );
      },
    );
  }
}

class EventCatagoryCardsView extends StatelessWidget {
  const EventCatagoryCardsView({
    super.key,
    required this.catagoryScrollController,
    required this.eventTypesCards,
  });

  final ScrollController catagoryScrollController;
  final List<Widget>? eventTypesCards;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // Constrain height for inner ListView
      child: ListView.separated(
        controller: catagoryScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: eventTypesCards!.length,
        itemBuilder: (context, index) {
          return eventTypesCards![index];
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 6);
        },
      ),
    );
  }
}
