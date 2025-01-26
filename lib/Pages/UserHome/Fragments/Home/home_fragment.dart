import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Models/user_details.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/all_events_view.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/details_of_event.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Components/event_catagory_view.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Pages/UserHome/Fragments/Home/Handlers/event_handler.dart';
import 'package:wo1/Widget/catagory_textview.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _MainPage();
}

class _MainPage extends State<HomeFragment> {
  bool isRefreshing = false;
  bool _isListening = false;
  String _searchText = '';
  double previousOffset = 0;

  final ScrollController catagoryScrollController = ScrollController();
  final textEditingController = TextEditingController();

  late final UserDetails userDetails;
  late EventHandler events;
  late stt.SpeechToText _speech;
  late AllEventsView allEventsView;

  ScrollController singleChildScrollViewController = ScrollController();
  ScrollController listViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    userDetails = ApiHandler.userDetails;
    events = EventHandler(showEventDetails: showEventDetails);
    events.loadData();
    allEventsView = AllEventsView(
      events: events,
      listViewController: listViewController,
      refreshPage: refreshPage,
    );
    _speech = stt.SpeechToText();
  }

  @override
  void didUpdateWidget(HomeFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
    //events.loadData(); // Reload events when the widget is updated
  }

  @override
  void dispose() {
    super.dispose();
    catagoryScrollController.dispose();
    textEditingController.dispose();
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            "Get a Partime job is now easy",
            style: TextStyle(
              color: Theme.of(context).highlightColor,
              fontSize: 16,
              fontFamily: 'Roboto',
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
              offset: Offset(0, 3),
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
              onPressed: filterEvents,
            ),
            hintText: 'Search Events',
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          ),
          controller: textEditingController,
        ),
      ),
    );
  }

  Expanded body() {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (!listViewController.hasClients) {
            return false;
          }

          if (listViewController.position.atEdge) {
            //loadmo
          }
          final currentOffset = listViewController.offset;

          if (currentOffset < previousOffset) {
            singleChildScrollViewController.animateTo(
              getScrollOffset(),
              duration: Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          } else if (currentOffset > previousOffset) {
            singleChildScrollViewController.animateTo(
              getScrollOffset(),
              duration: Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          }

          previousOffset = currentOffset;
          return true;
        },
        child: ListView(
          // reverse: true,
          controller: singleChildScrollViewController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 8),
            HeadingTextView(data: "Categories"),
            const SizedBox(height: 10),
            EventsCatagoryView(
              catagoryScrollController: catagoryScrollController,
              filterEvents: (eventName) => setState(() {
                events.filterEvents(eventName);
              }),
            ),
            const SizedBox(height: 10),
            HeadingTextView(data: "All Events"),
            const SizedBox(height: 8),
            allEventsView
          ],
        ),
      ),
    );
  }

  double getScrollOffset() {
    if (listViewController.offset < previousOffset &&
        singleChildScrollViewController.offset > 0) {
      return (singleChildScrollViewController.offset - 50)
          .clamp(0, singleChildScrollViewController.position.maxScrollExtent);
    }

    if (listViewController.offset > previousOffset) {
      return (singleChildScrollViewController.offset + 50)
          .clamp(0, singleChildScrollViewController.position.maxScrollExtent);
    }

    return singleChildScrollViewController.offset;
  }

  Future<void> refreshPage() async {
    setState(() {
      events.clear();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Listening...')),
        );
        _speech.listen(
          onResult: (val) => setState(() {
            _searchText = val.recognizedWords;
            textEditingController.text = _searchText;
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

  void _scrollToTop() {
    singleChildScrollViewController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    listViewController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void loadMore() {}
}
