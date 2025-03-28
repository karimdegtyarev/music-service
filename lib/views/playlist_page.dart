import 'package:flutter/material.dart';
import 'package:music_service/widgets/track_widget.dart';
import 'package:provider/provider.dart';
import '../models/track_model.dart';
import '../providers/player_provider.dart';

class PlaylistPage extends StatelessWidget {
  final List<Track> tracks;

  const PlaylistPage({super.key, required this.tracks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Плейлист'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          return TrackWidget(
            track: tracks[index],
            onTap: () {
              // Реализация воспроизведения
              final player = Provider.of<PlayerProvider>(context, listen: false);
              player.play(tracks[index]);
            },
          );
        },
      ),
    );
  }
}