import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_service/views/profile_page.dart';
import 'package:music_service/widgets/notifications.dart';

class SearchPage extends StatefulWidget {
  final notifications;

  const SearchPage({super.key, required this.notifications});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _showNotifications = false;
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
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
            icon: Stack(
              children: [
                Icon(
                  widget.notifications.isNotEmpty
                      ? Icons.notifications
                      : Icons.notifications_none,
                  color: Colors.lightGreenAccent,
                ),
                if (widget.notifications.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(widget.notifications.length.toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white)),
                    ),
                  ),
              ],
            ),
            onPressed: _toggleNotifications,
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
      body: Stack(
        children: [
          Column(
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
                          style:
                              const TextStyle(color: Colors.lightGreenAccent),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (_showNotifications)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleNotifications,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: Colors.black54,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(
                    top: kToolbarHeight +
                        MediaQuery.of(context).padding.top +
                        10,
                    right: 20,
                  ),
                  child: NotificationBanner(
                    notifications: widget.notifications,
                    onClose: _toggleNotifications,
                  ),
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  void _toggleNotifications() =>
      setState(() => _showNotifications = !_showNotifications);
}
