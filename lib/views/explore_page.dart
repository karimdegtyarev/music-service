import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

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
            log("ExplorePage");
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: const Text(
        'Каталоги',
        style: TextStyle(color: Colors.lightGreenAccent),
      ),
      backgroundColor: Colors.black,
    );
  }
}