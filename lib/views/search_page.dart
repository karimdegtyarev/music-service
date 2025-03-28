import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_service/services/track_parser.dart';
import 'package:music_service/views/profile_page.dart';
import 'package:music_service/widgets/track_widget.dart';

import '../models/track_model.dart';
import '../widgets/notifications.dart';

class SearchPage extends StatefulWidget {
  final List<String> notifications;

  const SearchPage({super.key, required this.notifications});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Track>> _tracksFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Track> _searchResults = [];
  bool _showNotifications = false;

  @override
  void initState() {
    super.initState();
    _tracksFuture = TrackParser.parseTracks();
  }

  void _onSearchChanged(String query) async {
    final allTracks = await _tracksFuture;

    setState(() {
      _searchResults = query.isEmpty
          ? []
          : allTracks
              .where((track) =>
                  track.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      backgroundColor: Colors.black,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white)),
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
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            _buildSearchField(),
            Expanded(
              child: _searchResults.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _searchResults.length,
                      itemBuilder: (_, index) =>
                          TrackWidget(track: _searchResults[index]),
                      separatorBuilder: (_, __) => const SizedBox(height: 0),
                    )
                  : _buildEmptyState(),
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
                  top: kToolbarHeight + MediaQuery.of(context).padding.top + 10,
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
    );
  }

  Widget _buildSearchField() {
    return Padding(
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
            fontSize: 15,
          ),
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: 'Find a music...',
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.lightGreen),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(15),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 64, color: Colors.green[900]),
          const SizedBox(height: 16),
          Text(
            'Start typing to find music',
            style: GoogleFonts.balsamiqSans(color: Colors.grey[400], fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _toggleNotifications() =>
      setState(() => _showNotifications = !_showNotifications);

// Остальные методы (кнопки, уведомления) остаются без изменений
}
