import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

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
            log("FavoritesPage");
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: const Text(
        'Любимые песни',
        style: TextStyle(color: Colors.lightGreenAccent),
      ),
      backgroundColor: Colors.black,
    );
  }
}