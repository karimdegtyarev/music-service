import 'package:flutter/material.dart';


class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: const Text(
        'Содержимое приложения',
        style: TextStyle(color: Colors.lightGreenAccent),
      ),
      //bottomNavigationBar: const BottomNavBar(),
      backgroundColor: Colors.black,
    );
  }
}