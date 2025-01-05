import 'package:flutter/material.dart';

class EventCatagoryView extends StatelessWidget {
  const EventCatagoryView({
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
