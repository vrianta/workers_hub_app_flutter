import 'package:flutter/material.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/event_handler.dart';

class EventsCatagoryView extends StatelessWidget {
  const EventsCatagoryView({
    super.key,
    required this.catagoryScrollController,
    required this.filterEvents,
    this.events, // Keep the old parameter for reference
  });

  final ScrollController catagoryScrollController;
  final EventHandler? events;
  final Function filterEvents; // Keep the old parameter for reference

  static const List<Map<String, dynamic>> eventTypes = [
    {"name": "Event", "shortName": "Event", "icon": Icons.event_outlined},
    {
      "name": "Marriage",
      "shortName": "Marriage",
      "icon": Icons.favorite_outline
    },
    {"name": "Party", "shortName": "Party", "icon": Icons.celebration_outlined},
    {"name": "Music", "shortName": "Music", "icon": Icons.music_note_outlined},
    {"name": "Birthday", "shortName": "B'day", "icon": Icons.cake_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> eventTypesCards = eventTypes.map((type) {
      return GestureDetector(
        onTap: () => filterEvents(type["name"]),
        child: Center(
          child: SizedBox(
            width: 140,
            height: 45,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: Colors.white,
              elevation: 5,
              shadowColor: const Color.fromARGB(85, 158, 158, 158),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    type["icon"],
                    size: 18,
                  ),
                  Text(
                    type["shortName"],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: EventCatagoryCardsView(
        catagoryScrollController: catagoryScrollController,
        eventTypesCards: eventTypesCards,
      ),
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
      height: 70,
      child: ListView.separated(
        controller: catagoryScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: eventTypesCards!.length,
        itemBuilder: (context, index) {
          return eventTypesCards![index];
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
      ),
    );
  }
}
