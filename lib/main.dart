//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic',
          style: GoogleFonts.aBeeZee(color: Colors.lightGreenAccent,fontSize: 40),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.lightGreenAccent,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.lightGreenAccent,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: const Text('Содержимое приложения', style: TextStyle(color: Colors.lightGreenAccent),),
      backgroundColor: Colors.black,
    );
  }
}
