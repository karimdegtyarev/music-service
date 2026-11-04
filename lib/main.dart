import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:music_service/services/playlist_parser.dart';
import 'package:music_service/views/explore_page.dart';
import 'package:music_service/views/favorites_page.dart';
import 'package:music_service/views/search_page.dart';
import 'package:music_service/widgets/bottom_nav_bar.dart';
import 'package:music_service/widgets/player_widget.dart';

import 'models/playlist_model.dart';
import 'views/home_page.dart';
import 'providers/player_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final playlistData = await PlaylistParser.parsePlaylists();

  runApp(
    ChangeNotifierProvider(
      create: (_) => PlayerProvider(),
      child: MyApp(playlistData: playlistData),
    ),
  );
}

class MyApp extends StatefulWidget {
  final PlaylistCategories playlistData;

  const MyApp({super.key, required this.playlistData});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    final notifications = [
      'Новый релиз: Arctic Monkeys - The Car',
      'Ваш персональный микс готов!',
      '3 новых подкаста в вашей подборке',
    ];

    _pages = [
      HomePage(
        playlistData: widget.playlistData,
        notifications: notifications,
      ),
      const ExplorePage(),
      const FavoritesPage(),
      SearchPage(notifications: notifications),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
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
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PlayerWidget(),
            BottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}
