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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          AppBar(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
              ),
            ],
          ),
          //const Text("Поиск", style: TextStyle(fontSize: 30,color: Colors.white),),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              style: GoogleFonts.permanentMarker(
                color: Colors.lightGreenAccent,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'Find a music',
                hintStyle: const TextStyle(
                  color: Colors.lightGreen,
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
          Expanded(
            child: Center(
              child: Text(
                'Music',
                style: GoogleFonts.permanentMarker(
                  color: Colors.lightGreenAccent,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
