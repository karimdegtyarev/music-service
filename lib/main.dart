import 'package:flutter/material.dart';
import 'package:music_service/views/explore_page.dart';
import 'package:music_service/views/favorites_page.dart';
import 'package:music_service/views/search_page.dart';
import 'package:music_service/widgets/bottom_nav_bar.dart';
import 'models/playlist_category.dart';
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
  //bool _showNotifications = false;

  // final List<String> _notifications = [
  //   'Новый релиз: Arctic Monkeys - The Car',
  //   'Ваш персональный микс готов!',
  //   '3 новых подкаста в вашей подборке'
  // ];

  // Перенесите объявление _categories перед _pages
  late final List<PlaylistCategory> _categories;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Инициализируем категории
    _categories = [
      PlaylistCategory(
        "Ваши миксы",
        [
          Playlist(
              "0",
              "Rock",
              "https://www.shutterstock.com/shutterstock/photos/2273777581/display_1500/stock-vector-rock-music-colorful-seamless-pattern-with-skulls-and-acoustic-guitar-for-playing-hard-rock-songs-at-2273777581.jpg",
              "Rammstein"),
          Playlist(
              "1",
              "Classic music",
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREBgcc52rmhqvEpAPtDW39iQkdbKYVfQfbfw&s",
              "Guitar Solo")
        ],
      ),
      PlaylistCategory(
        "Недавно прослушано",
        [
          Playlist(
              "0",
              "Rock",
              "https://www.culture.ru/s/slovo-dnya/abstraktsionizm/images/tild3434-3435-4664-b261-646661333865__photo.jpg",
              "Someting"),
          Playlist(
              "1",
              "Rock",
              "https://www.culture.ru/s/slovo-dnya/abstraktsionizm/images/tild3434-3435-4664-b261-646661333865__photo.jpg",
              "Someting"),
          Playlist(
              "2",
              "Rock",
              "https://www.culture.ru/s/slovo-dnya/abstraktsionizm/images/tild3434-3435-4664-b261-646661333865__photo.jpg",
              "Someting"),
          Playlist(
              "3",
              "Rock",
              "https://www.culture.ru/s/slovo-dnya/abstraktsionizm/images/tild3434-3435-4664-b261-646661333865__photo.jpg",
              "Someting")
        ],
      ),
    ];

    // Инициализируем страницы после категорий
    _pages = [
      HomePage(categorieslist: _categories),
      const ExplorePage(),
      const FavoritesPage(),
      const SearchPage(),
    ];
  }

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
        ));
  }
}
