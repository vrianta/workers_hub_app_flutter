import 'package:flutter/material.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/all_events_view.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/details_of_event.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/event_catagory_view.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/event_handler.dart';
import 'package:wo1/Widget/catagory_textview.dart';

class HomeFragment extends StatefulWidget {
  final ScrollController singleChildScrollViewController;
  final ScrollController listViewController;

  const HomeFragment(
      {required this.singleChildScrollViewController,
      required this.listViewController,
      super.key});

  @override
  State<HomeFragment> createState() => _MainPage();
}

class _MainPage extends State<HomeFragment> {
  bool isRefreshing = false;
  late EventHandler events;
  double previousOffset = 0;

  final ScrollController catagoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    events = EventHandler(showEventDetails: showEventDetails);
    events.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return mainPageView();
  }

  Scaffold mainPageView() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          // widget.listViewController.hasClients
          if (!widget.listViewController.hasClients) {
            return false;
          }
          final currentOffset = widget.listViewController.offset;

          if (currentOffset < previousOffset) {
            // User swiped up, scrolling up
            widget.singleChildScrollViewController.animateTo(
              getScrollOffset(),
              duration: Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          } else if (currentOffset > previousOffset) {
            // User swiped down, scrolling down
            widget.singleChildScrollViewController.animateTo(
              getScrollOffset(),
              duration: Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          }

          previousOffset = currentOffset;
          return true;
        },
        child: RefreshIndicator(
          onRefresh: _refreshPage,
          color: Colors.blueAccent,
          child: ListView(
            controller: widget.singleChildScrollViewController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 8),
              const HeadingTextView(data: "Category"),
              const SizedBox(height: 8),
              EventsCatagoryView(
                  events: events,
                  catagoryScrollController: catagoryScrollController),
              const SizedBox(height: 8),
              const HeadingTextView(data: "All Events"),
              const SizedBox(height: 8),
              AllEventsView(
                events: events,
                listViewController: widget.listViewController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      key: const Key("AppBar"),
      elevation: 0,
      title: Container(
        // Add padding to prevent text from touching edges
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

  double getScrollOffset() {
    // For upward swipe: Decrease the scroll offset slightly
    if (widget.listViewController.offset < previousOffset &&
        widget.singleChildScrollViewController.offset > 0) {
      return (widget.singleChildScrollViewController.offset - 50).clamp(
          0, widget.singleChildScrollViewController.position.maxScrollExtent);
    }

    // For downward swipe: Increase the scroll offset slightly
    if (widget.listViewController.offset > previousOffset) {
      return (widget.singleChildScrollViewController.offset + 50).clamp(
          0, widget.singleChildScrollViewController.position.maxScrollExtent);
    }

    // Default case: Return current offset
    return widget.singleChildScrollViewController.offset;
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

  void showEventDetails(Event event) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            height: 600,
            child: EventDetailsPage(
              event: event,
              onClose: () => {Navigator.pop(context), _refreshPage()},
            ),
          );
        });
  }
}
