import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchEventsPage extends StatefulWidget {
  const SearchEventsPage({super.key});

  @override
  State<SearchEventsPage> createState() => _SearchEventsPageState();
}

class _SearchEventsPageState extends State<SearchEventsPage> {
  bool _isListening = false;
  String _searchText = '';
  final textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late stt.SpeechToText _speech;

  @override
  void initState() {
    _speech = stt.SpeechToText();

    // Delay focus request to ensure it works properly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Events"),
      ),
      body: Column(
        children: [
          // Hero(tag: "SearchBar", child: searchBar()),
          searchBar(),
        ],
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
          focusNode: _focusNode,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(Icons.mic_outlined,
                  color: Theme.of(context).primaryColor),
              onPressed: _listen,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.search_outlined,
                  color: Theme.of(context).primaryColor),
              onPressed: () {},
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

  void _listen() async {
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    }

    bool available = await _speech.initialize(
      onError: (val) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $val')),
        );
      },
    );

    if (!available) {
      return;
    }

    setState(() => _isListening = true);
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Listening...')),
      );
    });

    _speech.listen(
      onResult: (val) => setState(() {
        _searchText = val.recognizedWords;
        textEditingController.text = _searchText;
      }),
    );
  }

  // void filterEvents() {
  //   setState(() {
  //     events.filterEvents(_searchText);
  //   });
  // }
}
