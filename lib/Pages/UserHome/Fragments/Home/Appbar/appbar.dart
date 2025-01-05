import 'package:flutter/material.dart';

class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppBarState();
}

class _AppBarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: const Key("AppBar"),
      elevation: 0,
      title: TextField(
        onChanged: (value) {
          setState(() {
            // _searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
          suffixIcon: Icon(Icons.search, color: Colors.black),
        ),
        style: const TextStyle(color: Colors.black),
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
}
