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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final Map<int,IconData> _icons = {
    0:Icons.home_outlined,
    1:Icons.explore_outlined,
    2:Icons.favorite_border,
    3:Icons.manage_search,
  };

  // Список иконок для активного состояния
  final Map<int,IconData> _activeIcons = {
    0:Icons.home,
    1:Icons.explore,
    2:Icons.favorite,
    3:Icons.search,
  };

  final List<String> _iconNames = [
    "Home",
    "Explore",
    "Favorites",
    "Search"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
            print("MainPage");
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.person_outline,
              color: Colors.lightGreenAccent,
            ),
            onPressed: () {},
          ),
        ],
      ),


      body: const Text(
        'Содержимое приложения',
        style: TextStyle(color: Colors.lightGreenAccent),
      ),


      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            return _buildNavItem(index);
          }),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? _activeIcons[index] : _icons[index],
            color: isSelected ? Colors.lightGreenAccent : Colors.white,
          ),
          Text(
            _iconNames[index],
            style: GoogleFonts.permanentMarker(
              color: isSelected ? Colors.lightGreenAccent : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dynamic',
          style: GoogleFonts.permanentMarker(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),
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
      body: const Text(
        'Содержимое',
        style: TextStyle(color: Colors.lightGreenAccent),
      ),
      backgroundColor: Colors.black,
    );
  }
}
