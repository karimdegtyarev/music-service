import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_service/views/profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _results = [];
  final List<String> _allMusic = [
    "Song 1",
    "Song 2",
    "Song 3",
    "Another Song",
    "More Music",
    "Song 4",
    "Song 5",
    "Song 6",
    "Another Song1",
    "More Music1",
  ];

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _results = [];
      } else {
        _results = _allMusic
            .where((song) => song.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            color: Colors.lightGreenAccent,
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            color: Colors.lightGreenAccent,
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
            onPressed: () {
              log("Navigating to Profile Page");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextSelectionTheme(
              data: const TextSelectionThemeData(
                cursorColor: Colors.lightGreenAccent,
                selectionColor: Colors.green,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,

                style: GoogleFonts.balsamiqSans(
                  color: Colors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.lightGreenAccent,
                  ),

                  hintText: 'Find a music',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _results.isNotEmpty,
            child: Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _results[index],
                      style: const TextStyle(color: Colors.lightGreenAccent),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}