import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_service/views/profile_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
            const HomePage();
          },
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.lightGreenAccent,
            ),
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
            onPressed: () {},
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
      body: const Text(
        'Главная',
        style: TextStyle(color: Colors.lightGreenAccent),
      ),
      backgroundColor: Colors.black,
    );
  }
}