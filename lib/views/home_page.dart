import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_service/models/playlist_category.dart';
import 'package:music_service/views/profile_page.dart';
import 'package:music_service/widgets/notifications.dart';
import 'package:music_service/widgets/playlist_category.dart';

class HomePage extends StatefulWidget {
  final List<PlaylistCategory> categorieslist;

  const HomePage({super.key, required this.categorieslist});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showNotifications = false;
  final List<String> _notifications = [
    'Новый релиз: Arctic Monkeys - The Car',
    'Ваш персональный микс готов!',
    '3 новых подкаста в вашей подборке'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          child: Text(
            'Dynamic',
            style: GoogleFonts.permanentMarker(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w900,
            ),
          ),
          onPressed: () {
            log("HomePage");
          },
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
            icon: Stack(
              children: [
                Icon(
                    _notifications.isNotEmpty
                        ? Icons.notifications
                        : Icons.notifications_none,
                    color: Colors.lightGreenAccent,),
                if (_notifications.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(_notifications.length.toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white)),
                    ),
                  ),
              ],
            ),
            onPressed: _toggleNotifications,
          ),
          IconButton(
            icon: const Icon(
              Icons.person_outline,
              color: Colors.lightGreenAccent,
            ),
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
            onPressed: () {
              log("Navigating to Profile Page");
              // Переход на страницу FavoritesPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Home",
                  style: GoogleFonts.balsamiqSans(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 24),
                  itemCount: widget.categorieslist.length,
                  itemBuilder: (context, index) {
                    return CategorySection(
                      category: widget.categorieslist[index],
                    );
                  },
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
                    notifications: _notifications,
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
