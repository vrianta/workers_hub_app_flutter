import 'package:flutter/material.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/all_events_view.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/details_of_event.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/event_catagory_view.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/event_handler.dart';
import 'package:wo1/Widget/catagory_textview.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  final textEditingController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchText = '';

  final GlobalKey _categoryKey = GlobalKey();
  final GlobalKey _allEventsKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    events = EventHandler(showEventDetails: showEventDetails);
    events.loadData();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building HomeFragment'); // Add this line
    return mainPageView();
  }

  Scaffold mainPageView() {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          searchBar(),
          body(),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 40.0,
        width: 40.0,
        child: FloatingActionButton(
          onPressed: _scrollToTop,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.arrow_upward, color: Colors.white),
        ),
      ),
    );
  }

  Expanded body() {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
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
        child: ListView(
          controller: widget.singleChildScrollViewController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 8),
            HeadingTextView(data: "Categories", key: _categoryKey),
            const SizedBox(height: 10),
            EventsCatagoryView(
              events: events,
              catagoryScrollController: catagoryScrollController,
              filterEvents: (eventName) => {
                setState(() {
                  events.filterEvents(eventName);
                }),
              },
            ),
            const SizedBox(height: 10),
            HeadingTextView(data: "All Events", key: _allEventsKey),
            const SizedBox(height: 8),
            AllEventsView(
              events: events,
              listViewController: widget.listViewController,
              refreshPage: refreshPage,
            ),
          ],
        ),
      ),
    );
  }

  Padding searchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(85, 158, 158, 158),
              spreadRadius: 5,
              blurRadius: 15,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(Icons.mic_outlined,
                  color: Theme.of(context).primaryColor),
              onPressed: _listen,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.search_outlined,
                  color: Theme.of(context).primaryColor),
              onPressed: () {
                filterEvents();
              },
            ),
            hintText: 'Search Events',
            border: InputBorder.none, // No border
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          ),
          controller: textEditingController,
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      key: const Key("AppBar"),
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Apply For Events",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 22, // Increased font size
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto', // Changed font family
            ),
          ),
          Text(
            "Get a Partime job is now easy",
            style: TextStyle(
              color: Theme.of(context).highlightColor,
              fontSize: 16, // Increased font size
              fontFamily: 'Roboto', // Changed font family
            ),
          ),
        ],
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 247, 247, 247),
              const Color.fromARGB(255, 247, 247, 247),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
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

  Future<void> refreshPage() async {
    setState(() {
      events.clear();
    });

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      events.loadData();
    });
  }

  void showEventDetails(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(
          event: event,
          onClose: () => {Navigator.pop(context), refreshPage()},
        ),
      ),
    );
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   builder: (BuildContext context) {
    //     return Container(
    //       padding: const EdgeInsets.all(16.0),
    //       height: 600,
    //       child: EventDetailsPage(
    //         event: event,
    //         onClose: () => {Navigator.pop(context), refreshPage()},
    //       ),
    //     );
    //   },
    // );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onError: (val) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $val')),
          );
        },
      );
      if (available) {
        setState(() => _isListening = true);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Listening...')),
        );
        _speech.listen(
          onResult: (val) => setState(() {
            _searchText = val.recognizedWords;
            textEditingController.text = _searchText;
            // Update the search field with the recognized text
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void filterEvents() {
    setState(() {
      events.filterEvents(_searchText);
    });
  }

  void _scrollToAllEvents() {
    final categoryContext = _categoryKey.currentContext;
    final allEventsContext = _allEventsKey.currentContext;

    if (categoryContext != null && allEventsContext != null) {
      Scrollable.ensureVisible(
        allEventsContext,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToTop() {
    widget.singleChildScrollViewController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    widget.listViewController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
