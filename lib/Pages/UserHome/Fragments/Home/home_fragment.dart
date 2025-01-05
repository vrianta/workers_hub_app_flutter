import 'package:flutter/material.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/all_events_view.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/event_catagory_view.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/events.dart';
import 'package:wo1/Widget/catagory_textview.dart';

class HomeFragment extends StatefulWidget {
  final ScrollController singleChildScrollViewController;
  final ScrollController listViewController;

  const HomeFragment(
      {required this.singleChildScrollViewController,
      required this.listViewController,
      super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  bool isRefreshing = false;
  EventHandler events = EventHandler();
  late Future<List<Widget>> eventCardsTypeFuture;

  final ScrollController catagoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    events.loadData();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.listViewController.addListener(() {
        if (widget.listViewController.offset == 0) {
          widget.singleChildScrollViewController.animateTo(0,
              duration: const Duration(microseconds: 100),
              curve: Curves.linear);
        } else {
          widget.singleChildScrollViewController.animateTo(10,
              duration: const Duration(microseconds: 100),
              curve: Curves.linear);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        color: Colors.blueAccent,
        child: SingleChildScrollView(
          controller: widget.singleChildScrollViewController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const HeadingTextView(data: "Category"),
              const SizedBox(height: 8),
              categoryContainer(),
              const SizedBox(height: 8),
              const HeadingTextView(data: "All Events"),
              const SizedBox(height: 8),
              AllEventsView(events: events, widget: widget),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<Widget>> categoryContainer() {
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
          child: EventCatagoryView(
              catagoryScrollController: catagoryScrollController,
              eventTypesCards: eventTypesCards),
        );
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      key: const Key("AppBar"),
      elevation: 0,
      title: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.black),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Implement your filter logic here
                // showFilterDialog();
              },
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            // Implement your filter logic here
            // showFilterDialog();
          },
        ),
      ],
      backgroundColor: Colors.white,
    );
  }

  Future<void> _refreshPage() async {
    setState(() {
      events.clear();
    });

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      events.loadData();
    });
  }
}
