import 'package:flutter/material.dart';
import 'package:music_service/views/explore_page.dart';
import 'package:music_service/views/favorites_page.dart';
import 'package:music_service/views/search_page.dart';
import 'package:music_service/widgets/bottom_nav_bar.dart';
import 'views//home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ExplorePage(),
    const FavoritesPage(),
    const SearchPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic',
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      )
    );
  }
}